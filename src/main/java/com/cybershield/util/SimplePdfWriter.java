package com.cybershield.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

/**
 * Minimal, dependency-free PDF generator for simple text documents (a
 * title plus a list of label/value lines). Writes raw PDF syntax directly -
 * no iText/PDFBox/Apache dependency required, since this project has no
 * reliable way to fetch third-party binary jars into WEB-INF/lib.
 *
 * Handles automatic line wrapping and multi-page overflow. Sized for the
 * "complaint receipt" use case (a few dozen short fields), not general
 * document layout.
 */
public class SimplePdfWriter {

    private static final float PAGE_WIDTH = 595f;  // A4 in points
    private static final float PAGE_HEIGHT = 842f;
    private static final float MARGIN = 50f;
    private static final float LINE_HEIGHT = 16f;
    private static final float TITLE_SIZE = 18f;
    private static final float BODY_SIZE = 11f;
    private static final float LABEL_SIZE = 11f;

    private final String title;
    private final List<String[]> fields = new ArrayList<>(); // {label, value}

    public SimplePdfWriter(String title) {
        this.title = title;
    }

    public void addField(String label, String value) {
        fields.add(new String[]{label, value == null || value.isEmpty() ? "-" : value});
    }

    /** Renders the accumulated title + fields into PDF bytes. */
    public byte[] build() throws IOException {
        List<String> lines = new ArrayList<>();
        for (String[] f : fields) {
            String prefix = f[0] + ": ";
            wrapInto(lines, prefix, f[1]);
            lines.add(""); // spacer between fields
        }

        // Paginate
        List<List<String>> pages = new ArrayList<>();
        List<String> current = new ArrayList<>();
        float y = PAGE_HEIGHT - MARGIN - TITLE_SIZE - 20;
        int maxLinesFirstPage = (int) ((y - MARGIN) / LINE_HEIGHT);
        int maxLinesOtherPages = (int) ((PAGE_HEIGHT - 2 * MARGIN) / LINE_HEIGHT);

        int limit = maxLinesFirstPage;
        for (String line : lines) {
            if (current.size() >= limit) {
                pages.add(current);
                current = new ArrayList<>();
                limit = maxLinesOtherPages;
            }
            current.add(line);
        }
        pages.add(current);

        return renderPdf(pages);
    }

    private void wrapInto(List<String> out, String prefix, String value) {
        int maxCharsPerLine = 92;
        String combined = prefix + value.replace("\r", " ").replace("\n", " ");
        while (combined.length() > maxCharsPerLine) {
            int breakAt = combined.lastIndexOf(' ', maxCharsPerLine);
            if (breakAt <= 0) breakAt = maxCharsPerLine;
            out.add(combined.substring(0, breakAt));
            combined = "   " + combined.substring(breakAt).trim();
        }
        out.add(combined);
    }

    private byte[] renderPdf(List<List<String>> pages) throws IOException {
        ByteArrayOutputStream pdf = new ByteArrayOutputStream();
        List<Integer> offsets = new ArrayList<>();

        write(pdf, "%PDF-1.4\n");

        int objNum = 1;
        int catalogObj = objNum++;
        int pagesObj = objNum++;
        int fontObj = objNum++;
        int fontBoldObj = objNum++;

        List<Integer> pageObjNums = new ArrayList<>();
        List<Integer> contentObjNums = new ArrayList<>();
        for (int i = 0; i < pages.size(); i++) {
            pageObjNums.add(objNum++);
            contentObjNums.add(objNum++);
        }

        // 1. Catalog
        offsets.add(pdf.size());
        write(pdf, catalogObj + " 0 obj\n<< /Type /Catalog /Pages " + pagesObj + " 0 R >>\nendobj\n");

        // 2. Pages
        StringBuilder kids = new StringBuilder();
        for (int p : pageObjNums) kids.append(p).append(" 0 R ");
        offsets.add(pdf.size());
        write(pdf, pagesObj + " 0 obj\n<< /Type /Pages /Kids [" + kids.toString().trim() + "] /Count " + pages.size() + " >>\nendobj\n");

        // 3. Fonts
        offsets.add(pdf.size());
        write(pdf, fontObj + " 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n");
        offsets.add(pdf.size());
        write(pdf, fontBoldObj + " 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj\n");

        // 4. Pages + content streams
        for (int i = 0; i < pages.size(); i++) {
            int pageObj = pageObjNums.get(i);
            int contentObj = contentObjNums.get(i);

            offsets.add(pdf.size());
            write(pdf, pageObj + " 0 obj\n<< /Type /Page /Parent " + pagesObj + " 0 R "
                    + "/Resources << /Font << /F1 " + fontObj + " 0 R /F1B " + fontBoldObj + " 0 R >> >> "
                    + "/MediaBox [0 0 " + PAGE_WIDTH + " " + PAGE_HEIGHT + "] "
                    + "/Contents " + contentObj + " 0 R >>\nendobj\n");

            String stream = buildContentStream(pages.get(i), i == 0);
            byte[] streamBytes = stream.getBytes("ISO-8859-1");

            offsets.add(pdf.size());
            write(pdf, contentObj + " 0 obj\n<< /Length " + streamBytes.length + " >>\nstream\n");
            pdf.write(streamBytes);
            write(pdf, "\nendstream\nendobj\n");
        }

        int xrefStart = pdf.size();
        int totalObjs = objNum - 1;
        write(pdf, "xref\n0 " + (totalObjs + 1) + "\n");
        write(pdf, "0000000000 65535 f \n");
        for (int off : offsets) {
            write(pdf, String.format("%010d 00000 n \n", off));
        }
        write(pdf, "trailer\n<< /Size " + (totalObjs + 1) + " /Root " + catalogObj + " 0 R >>\n");
        write(pdf, "startxref\n" + xrefStart + "\n%%EOF");

        return pdf.toByteArray();
    }

    private String buildContentStream(List<String> lines, boolean isFirstPage) {
        StringBuilder sb = new StringBuilder();
        sb.append("BT\n");
        float y = PAGE_HEIGHT - MARGIN;

        if (isFirstPage) {
            sb.append("/F1B ").append(TITLE_SIZE).append(" Tf\n");
            sb.append(MARGIN).append(" ").append(y).append(" Td\n");
            sb.append("(").append(escape(title)).append(") Tj\n");
            y -= (TITLE_SIZE + 20);
            sb.append("0 ").append(-(TITLE_SIZE + 20)).append(" Td\n");
            sb.append("/F1 ").append(BODY_SIZE).append(" Tf\n");
        } else {
            y -= TITLE_SIZE;
            sb.append("/F1 ").append(BODY_SIZE).append(" Tf\n");
            sb.append(MARGIN).append(" ").append(y).append(" Td\n");
        }

        for (String line : lines) {
            sb.append("(").append(escape(line)).append(") Tj\n");
            sb.append("0 ").append(-LINE_HEIGHT).append(" Td\n");
        }

        sb.append("ET");
        return sb.toString();
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    private void write(ByteArrayOutputStream out, String s) throws UnsupportedEncodingException {
        out.write(s.getBytes("ISO-8859-1"), 0, s.getBytes("ISO-8859-1").length);
    }
}
