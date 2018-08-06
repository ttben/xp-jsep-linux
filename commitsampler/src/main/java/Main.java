import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

public class Main {
    public static void main(String[] args) {
        Map<String, Map<String, List<String>>> mapYearToMonthToHashes = new HashMap<>();

        String csvFile = "./gitlog1718.commits";
        String line = "";
        String cvsSplitBy = ";";

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {

            while ((line = br.readLine()) != null) {
                String[] lineContent = line.split(cvsSplitBy);

                String date = lineContent[0];
                String commitHash = lineContent[1];

                String[] dateSplitted = date.split("-");
                String year = dateSplitted[0];
                String month = dateSplitted[1];
                String day = dateSplitted[2];

                Map<String,  List<String>> mapYear = new HashMap<>();
                if (mapYearToMonthToHashes.containsKey(year)) {
                    mapYear = mapYearToMonthToHashes.get(year);
                }

                List<String> hashes = new ArrayList<>();
                if (mapYear.containsKey(month)) {
                    hashes = mapYear.get(month);
                }

                hashes.add(commitHash);
                mapYear.put(month, hashes);
                mapYearToMonthToHashes.put(year, mapYear);

            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        // Take one each month
        List<String> selectedCommits = new ArrayList<>();
        for (Map.Entry<String, Map<String, List<String>>> yearMonthEntrySet : mapYearToMonthToHashes.entrySet()) {
            Map<String, List<String>> monthHashesMap = yearMonthEntrySet.getValue();
            for (Map.Entry<String, List<String>> monthHashesEntrySet : monthHashesMap.entrySet()) {
                List<String> currentHashes = monthHashesEntrySet.getValue();
                Random rand = new Random();
                String randomlySelectedCommitHash = currentHashes.get(rand.nextInt(currentHashes.size()));
                selectedCommits.add(randomlySelectedCommitHash);
                System.err.printf("%s;%s;%s\n",yearMonthEntrySet.getKey(),monthHashesEntrySet.getKey(),randomlySelectedCommitHash);
            }
        }

        //        2018;01;7007ba630e4a
        //        2018;02;ce8d1015a2b8
        //        2018;03;847ecd3fa311
        //        2018;04;15b4dd798149
        //        2018;05;bce1a65172d1
        //        2018;06;2551a53053de
        //        2018;07;bfd40eaff5ab
        //        2017;11;2f53fbd52182
        //        2017;01;ec663d967b22
        //        2017;12;827ed2b06b05
        //        2017;02;e71ff89c712c
        //        2017;03;5003ae1e735e
        //        2017;04;96801b35f07e
        //        2017;05;38651683aa98
        //        2017;06;4efe37f4c4ef
        //        2017;07;b134bd90286d
        //        2017;08;25a3ba610609
        //        2017;09;0d4a6608f68c
        //        2017;10;78109d230b79
    }
}
