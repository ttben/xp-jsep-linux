library(ggplot2)

root_folder_of_csv_files="/Users/bennibenjamin/Work/xp-jsep-linux/csv-files"
root_folder_of_result_graphs="/Users/bennibenjamin/Work/fix-interferences/resources"
#xp-jsep-linux/graphs

pdf(paste(root_folder_of_result_graphs, "exectimes_phase1-slow.pdf", sep="/"), width=12, height=8, paper='special')
exectimes_phase1 <- read.csv(paste(root_folder_of_csv_files, "phase1.csv", sep="/") , sep=";")
gr <- ggplot(
      exectimes_phase1,
      aes(x=semantic.patch, y=elapsed.real.time), main=2
  ) +
  geom_boxplot() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    axis.text=element_text(size=10),
    axis.title=element_text(size=14,face="bold")) +
  labs(x = "Semantic patch", y = "Computing time in seconds") + ylim(300, 3000)
gr
dev.off()



pdf(paste(root_folder_of_result_graphs, "exectimes_phase1-slow.pdf", sep="/"), width=12, height=8, paper='special')
data_phase1_greaterthan5m <- exectimes_phase1[(exectimes_phase1[,4]>300),]
gr <- ggplot(
      data_phase1_greaterthan5m,
      aes(x=semantic.patch, y=elapsed.real.time), main=2
  ) +
  geom_boxplot() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    axis.text=element_text(size=10),
    axis.title=element_text(size=14,face="bold")) +
  labs(x = "Semantic patch", y = "Computing time in seconds")
gr
dev.off()




pdf(paste(root_folder_of_result_graphs, "exectimes_phase1-fast.pdf", sep="/"), width=12, height=8, paper='special')
data_phase1_lowerthan5m <- exectimes_phase1[(exectimes_phase1[,4]<=300),]
gr <- ggplot(
      data_phase1_lowerthan5m,
      aes(x=semantic.patch, y=elapsed.real.time), main=2
  ) +
  geom_boxplot() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    axis.text=element_text(size=10),
    axis.title=element_text(size=14,face="bold")) +
  labs(x = "Semantic patch", y = "Computing time in seconds")
gr
dev.off()







list_sp_fail_success <- read.csv(paste(root_folder_of_csv_files, "list-sp-fail-success.csv", sep="/") , sep=";")





pdf(paste(root_folder_of_result_graphs, "chart-interactions-per-commit.pdf", sep="/"), width=5, height=6, paper='special')

fail_success_interactions <- read.csv(paste(root_folder_of_csv_files, "sp-fail-success.csv", sep="/") , sep=";")
fail_success_interactions$falsetrue <- NULL
fail_success_interactions$falsefalse <- NULL
fail_success_interactions$truefalse <- NULL


gr <- ggplot(
      fail_success_interactions,
      aes(x=commit.id, y=truetrue), main=2
  ) + ylim(1, 5) + geom_bar(stat = "identity", width = 0.6) + theme_bw() + theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    axis.text=element_text(size=8),
    axis.title=element_text(size=12,face="bold")) + labs(x = "Commit", y = "Number of interactions detected")

gr
dev.off()




pdf(paste(root_folder_of_result_graphs, "exectimes_phase2.pdf", sep="/"),width=12, height=8, paper='special')
exectimes_phase2 <- read.csv(paste(root_folder_of_csv_files, "phase2.csv", sep="/") , sep=";")
gr <- ggplot(
    exectimes_phase2,
    aes(x=semantic.patch, y=elapsed.real.time), main=2
  ) +
  geom_boxplot() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    axis.text=element_text(size=10),
    axis.title=element_text(size=14,face="bold")) +
  labs(x = "Semantic patch", y = "Computing time in seconds")
gr
dev.off()




pdf(paste(root_folder_of_result_graphs, "exectimes_global.pdf", sep="/"),width=18, height=12, paper='special')
exectimes_global <- read.csv(paste(root_folder_of_csv_files, "global-exec-times.csv", sep="/") , sep=";")
gr <- ggplot(data=exectimes_global, aes(x=commit.id.phase.1, y=duration.in.min), main=2) +   geom_boxplot() +
theme(
axis.text.x = element_text(angle = 90, hjust = 1),
axis.text=element_text(size=18),
axis.title=element_text(size=20,face="bold")
          ) + geom_bar(stat="identity")+
        labs(x = "Commit", y = "Computing time in minutes")  + geom_hline(yintercept = mean(exectimes_global$duration.in.min), color="blue")
gr
dev.off()




pdf(paste(root_folder_of_result_graphs, "copy-kernel-time.pdf", sep="/"),width=4, height=10, paper='special')
copying_kernel_time <- read.csv(paste(root_folder_of_csv_files, "copy-kernel-times.csv", sep="/") , sep=";")
gr <- ggplot(copying_kernel_time, aes(y=elapsed.real.time, main=2)) + geom_boxplot() + theme(
  axis.text=element_text(size=26),
  axis.title=element_text(size=28,face="bold"),
  axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + labs(y = "Computing time in seconds")
gr
dev.off();



pdf(paste(root_folder_of_result_graphs, "nb-semantic-patches.pdf", sep="/"),width=4, height=18, paper='special')
copying_kernel_time <- read.csv(paste(root_folder_of_csv_files, "nb-semantic-patches.csv", sep="/") , sep=";")
p<-ggplot(data=copying_kernel_time, aes(x=commit.id, y=nb.patches)) +
theme(           axis.text=element_text(size=24),
          axis.title=element_text(size=26,face="bold")) +
  geom_bar(stat="identity")
p
dev.off();


list_sp_fail_success <- read.csv(paste(root_folder_of_csv_files, "sp-fail-success.csv", sep="/") , sep=";")
p <- p + geom_text(data=copying_kernel_time, aes(x = year, y = percentage,
                                             label = paste0(percentage,"%")), size=4)
p


g <- ggplot(list_sp_fail_success, aes(commit.id))
g <- g + geom_bar()
