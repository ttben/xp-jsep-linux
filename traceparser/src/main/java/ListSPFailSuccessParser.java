import javafx.util.Pair;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class ListSPFailSuccessParser {
    public static void main(String[] args) throws IOException {
        StringBuilder result = new StringBuilder();
        result.append("commit.id;falsefalse;falsetrue;truefalse;truetrue\n");

        Map<String, Map<String, Pair<Boolean, Boolean>>> data = parse("/Users/bennibenjamin/Work/xp-jsep-linux/csv-files/list-sp-fail-success.csv");
        for (String commitID : data.keySet()) {
            int falsefalse = 0, falsetrue = 0, truetrue = 0, truefalse = 0;

            for (String sp : data.get(commitID).keySet()) {
                Pair<Boolean, Boolean> phases = data.get(commitID).get(sp);
                if (phases.getKey() && phases.getValue()) {
                    truetrue++;
                }
                if (phases.getKey() && !phases.getValue()) {
                    truefalse++;
                }
                if (!phases.getKey() && phases.getValue()) {
                    falsetrue++;
                }
                if (!phases.getKey() && !phases.getValue()) {
                    falsefalse++;
                }
            }

            result.append(commitID).append(";").append(falsefalse).append(";").append(falsetrue).append(";").append(truefalse).append(";").append(truetrue).append("\n");
        }

        Parser.writeToFile("sp-fail-success.csv", result.toString());
    }

    public static Map<String, Map<String, Pair<Boolean, Boolean>>> parse(String pathToFile) throws IOException {
        Map<String, Map<String, Pair<Boolean, Boolean>>> data = new HashMap<>();


        BufferedReader br = new BufferedReader(new FileReader(pathToFile));
        String line;

        br.readLine(); // skip header

        while ((line = br.readLine()) != null) {
            String[] split = line.split(";");

            String commitID = split[0];
            String semanticPatch = split[1];
            Boolean phase1Success = Boolean.parseBoolean(split[2]);
            Boolean phase2Success = Boolean.parseBoolean(split[3]);

            Map<String, Pair<Boolean, Boolean>> currentCommitData = new HashMap<>();
            if (data.containsKey(commitID)) {
                currentCommitData = data.get(commitID);
            }

            Pair<Boolean, Boolean> currentStatuses = new Pair<>(phase1Success, phase2Success);
            currentCommitData.put(semanticPatch, currentStatuses);
            data.put(commitID, currentCommitData);
        }
        return data;
    }
}
