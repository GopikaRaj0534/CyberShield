package com.cybershield.ai;

import com.cybershield.util.ConfigUtil;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class AIService {

    /**
     * Executes the Python AI risk prediction engine.
     * @param url Suspect URL
     * @param email Suspect Email
     * @param description Crime description
     * @return String array: [0] = Risk Category (LOW, MEDIUM, HIGH), [1] = Model Explanation
     */
    public static String[] analyzeThreat(
            String url,
            String email,
            String description
    ){
        String risk = "LOW";
        String explanation = "AI model did not generate an explanation.";

        try {
            String aiDir = ConfigUtil.get("ai.script.dir");
            String pythonCmd = ConfigUtil.get("ai.python.command", "python");
            String scriptPath = aiDir + File.separator + "risk_predictor.py";

            ProcessBuilder pb = new ProcessBuilder(
                    pythonCmd,
                    scriptPath,
                    url == null ? "" : url,
                    email == null ? "" : email,
                    description == null ? "" : description
            );
            pb.directory(new File(aiDir));

            Process process = pb.start();

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while((line = reader.readLine()) != null){
                    System.out.println("PYTHON OUTPUT: " + line);
                    if (line.startsWith("RISK:")) {
                        risk = line.substring(5).trim().toUpperCase();
                    } else if (line.startsWith("EXPLANATION:")) {
                        explanation = line.substring(12).trim();
                    }
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
            explanation = "Failed to run AI model: " + e.getMessage();
        }

        return new String[] { risk, explanation };
    }
}