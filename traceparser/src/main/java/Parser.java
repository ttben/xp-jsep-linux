import javafx.util.Pair;

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Parser {
    public static final String PATH_TO_CSV_FOLDER = "/Users/bennibenjamin/Work/xp-jsep-linux/csv-files/";

    public static void main(String[] args) throws IOException, ParseException {
        List<File> traceFiles = loadTraceFiles();
        Map<String, List<Pair<String, String>>> data = parseTraceFiles(traceFiles);

        Map<String, List<Pair<String, String>>> dataPhase1 = new HashMap<>();
        Map<String, List<Pair<String, String>>> dataApplyPatches = new HashMap<>();
        Map<String, List<Pair<String, String>>> dataPhase2 = new HashMap<>();
        extractPhasesData(data, dataPhase1, dataApplyPatches, dataPhase2);

        writeToFile("global-exec-times.csv", generateCSVForExecTime(data));
        writeToFile("copy-kernel-times.csv", generateCSVForCopyingKernel(data));
        writeToFile("nb-semantic-patches.csv", generateCSVForSemanticPatchesEvolution(data));
        writeToFile("phase1.csv", generateCSVForPhase(dataPhase1));
        writeToFile("phase2.csv", generateCSVForPhase(dataPhase2));
    }

    private static String generateCSVForSemanticPatchesEvolution(Map<String, List<Pair<String, String>>> data) {
        StringBuilder contentBuilder = new StringBuilder();

        List<Pair<String, String>> listPairCommitNbPatches = data.get("nb_cocci_scripts");

        contentBuilder.append("commit.id;nb.patches\n");

        for (Pair<String, String> pairCommitNbPatches : listPairCommitNbPatches) {
            String commitID = pairCommitNbPatches.getKey();
            String nbPatchesStr = pairCommitNbPatches.getValue();
            contentBuilder.append(commitID).append(";").append(nbPatchesStr).append("\n");
        }

        return contentBuilder.toString();
    }

    private static String generateCSVForCopyingKernel(Map<String, List<Pair<String, String>>> data) {
        StringBuilder contentBuilder = new StringBuilder();

        List<Pair<String, String>> listPairCommitCopyKernelTime = data.get("copying_kernel");
        contentBuilder.append("commit.id;exit.status;perc.of.cpu;elapsed.real.time;elapsed.system.time;elapsed.user.time").append("\n");

        for (Pair<String, String> pairCommitCopyKernelTime : listPairCommitCopyKernelTime) {
            String commitID = pairCommitCopyKernelTime.getKey();
            String copyKernelTime = pairCommitCopyKernelTime.getValue();
            contentBuilder.append(commitID).append(";").append(copyKernelTime).append("\n");
        }
        return contentBuilder.toString();
    }

    private static String generateCSVForExecTime(Map<String, List<Pair<String, String>>> data) throws ParseException {
        StringBuilder contentBuilder = new StringBuilder();
        contentBuilder.append("duration.in.min").append("\n");
        List<Pair<String, String>> startDates = data.get("start_date");
        List<Pair<String, String>> endDates = data.get("end_date");

        for (Pair<String, String> pairOfStartDates : startDates) {
            String commitID = pairOfStartDates.getKey();
            String startDateStr = pairOfStartDates.getValue();
            for (Pair<String, String> pairOfEndDates : endDates) {
                if (pairOfEndDates.getKey().equals(commitID)) {
                    String endDateStr = pairOfEndDates.getValue();

                    String pattern = "EEE, dd MMM yyyy HH:mm:ss Z";
                    SimpleDateFormat format = new SimpleDateFormat(pattern, Locale.ENGLISH);
                    Date startDate = format.parse(startDateStr);
                    Date endDate = format.parse(endDateStr);

                    long duration = endDate.toInstant().toEpochMilli() - startDate.toInstant().toEpochMilli();
                    contentBuilder.append(duration / 60000).append("\n");
                }
            }
        }

        return contentBuilder.toString();
    }

    private static String generateCSVForPhase(Map<String, List<Pair<String, String>>> dataPhase) {
        StringBuilder contentBuilder = new StringBuilder();

        /*
        time -f "%x;%P;%e;%S;%U" sh -c "$command_to_exec"

          # %P   percent of CPU this job got
          # %e   elapsed real time (wall clock) in seconds
          # %S   system (kernel) time in seconds
          # %U   user time in seconds
          # %x   exit status of command
         */
        contentBuilder.append("semantic.patch;exit.status;perc.of.cpu;elapsed.real.time;elapsed.system.time;elapsed.user.time").append("\n");
        for (String key : dataPhase.keySet()) {
            List<Pair<String, String>> values = dataPhase.get(key);

            for (Pair<String, String> value : values) {
                contentBuilder.append(key).append(";");
                contentBuilder.append(value.getValue());
                contentBuilder.append("\n");
            }

        }
        return contentBuilder.toString();
    }

    private static void extractPhasesData(Map<String, List<Pair<String, String>>> data,
                                          Map<String, List<Pair<String, String>>> dataPhase1,
                                          Map<String, List<Pair<String, String>>> dataApplyPatches,
                                          Map<String, List<Pair<String, String>>> dataPhase2) {
        for (String currentKey : data.keySet()) {

            if (currentKey.contains("time_generate_patches_phase-1-")) {
                String newKey = currentKey.split("time_generate_patches_phase-1-")[1];
                dataPhase1.put(newKey, data.get(currentKey));
            } else if (currentKey.contains("time_generate_patches_phase-2-")) {
                String newKey = currentKey.split("time_generate_patches_phase-2-")[1];
                dataPhase2.put(newKey, data.get(currentKey));
            } else {
                if (currentKey.startsWith("/tmp/")) {
                    String[] split = currentKey.split("/");
                    String newKey = split[split.length - 1];

                    List<Pair<String, String>> oldDataApplyPatchPairs = new ArrayList<>();
                    if (dataApplyPatches.containsKey(newKey)) {
                        oldDataApplyPatchPairs = dataApplyPatches.get(newKey);
                    }
                    oldDataApplyPatchPairs.addAll(data.get(currentKey));

                    dataApplyPatches.put(newKey, oldDataApplyPatchPairs);
                }
            }
        }
    }

    private static Map<String, List<Pair<String, String>>> parseTraceFiles(List<File> traceFiles) throws IOException {
        Map<String, List<Pair<String, String>>> data = new HashMap<>();
        // map key metric (eg nb-cocci-scripts) --> [ (commitID,value), ...  ]

        for (File traceFile : traceFiles) {

            String commitID = findCommitID(traceFile);

            BufferedReader br = new BufferedReader(new FileReader(traceFile));
            String line;

            while ((line = br.readLine()) != null) {
                String[] split = line.split(":");

                if (line.startsWith("/tmp/")) {
                    if (line.contains("Command exited with non-zero")) {
                        split = new String[]{split[0], "-1;" + br.readLine()};
                    } else {
                        split = new String[]{split[0], "0;" + split[1]};

                    }
                }

                if (split.length != 2) {

                    // handle date case
                    if (split[0].startsWith("start_date") || split[0].startsWith("end_date")) {
                        String date = "";
                        for (int i = 1; i < split.length; i++) {
                            date = date.concat(split[i]);
                            if (i != split.length - 1) {
                                date = date.concat(":");
                            }
                        }

                        split = new String[]{split[0], date};
                    }
                }

                String keyMetric = split[0].trim();
                String value = split[1].trim();
                Pair<String, String> pair = new Pair<>(commitID, value);

                List<Pair<String, String>> dataForKeyMetric = new ArrayList<>();
                if (data.containsKey(keyMetric)) {
                    dataForKeyMetric = data.get(keyMetric);
                }

                dataForKeyMetric.add(pair);
                data.put(keyMetric, dataForKeyMetric);
            }

        }
        return data;
    }

    private static String findCommitID(File traceFile) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(traceFile));
        String line = br.readLine();

        while (line != null) {
            if (line.startsWith("handle_commit")) {
                return line.split(":")[1].trim();
            }
            line = br.readLine();
        }

        return null;
    }

    public static List<File> loadTraceFiles() {
        List<File> result = new ArrayList<>();

        result.add(new File("/Users/bennibenjamin/Desktop/trace.log"));
        result.add(new File("/Users/bennibenjamin/Desktop/trace2.log"));
        result.add(new File("/Users/bennibenjamin/Desktop/trace3.log"));

        return result;
    }

    public static void writeToFile(String filename, String content) throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(PATH_TO_CSV_FOLDER + filename));
        writer.write(content);
        writer.close();
    }
}
