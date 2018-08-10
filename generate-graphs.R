library(ggplot2)

root_folder_of_csv_files="/Users/bennibenjamin/Work/xp-jsep-linux/csv-files"
root_folder_of_result_graphs="/Users/bennibenjamin/Work/xp-jsep-linux/graphs"

pdf(paste(root_folder_of_result_graphs, "exectimes_phase1.pdf", sep="/"), width=12, height=8, paper='special')
exectimes_phase1 <- read.csv(paste(root_folder_of_csv_files, "phase1.csv", sep="/") , sep=";")
gr <- ggplot(exectimes_phase1, aes(x=semantic.patch, y=elapsed.real.time), main=1) + geom_boxplot() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
gr
dev.off()

pdf(paste(root_folder_of_result_graphs, "exectimes_phase2.pdf", sep="/"),width=12, height=8, paper='special')
exectimes_phase2 <- read.csv(paste(root_folder_of_csv_files, "phase2.csv", sep="/") , sep=";")
gr <- ggplot(exectimes_phase2, aes(x=semantic.patch, y=elapsed.real.time), main=2) + geom_boxplot() + theme(axis.text.x = element_text(angle = 90, hjust = 1))
gr
dev.off()

pdf(paste(root_folder_of_result_graphs, "exectimes_global.pdf", sep="/"),width=6, height=18, paper='special')
exectimes_global <- read.csv(paste(root_folder_of_csv_files, "global-exec-times.csv", sep="/") , sep=";")
gr <- ggplot(exectimes_global, aes(y=duration.in.min), main=2) + geom_boxplot() + theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text=element_text(size=20),
          axis.title=element_text(size=22,face="bold")
          #, plot.caption = element_text(hjust=0.5, size=rel(1.2))
         ) # + labs(caption="Execution time to apply 59 semantic patches and check them")
gr
dev.off()


pdf(paste(root_folder_of_result_graphs, "copy-kernel-time.pdf", sep="/"),width=6, height=18, paper='special')
copying_kernel_time <- read.csv(paste(root_folder_of_csv_files, "copy-kernel-times.csv", sep="/") , sep=";")
gr <- ggplot(copying_kernel_time, aes(y=elapsed.real.time, main=2) + geom_boxplot() + theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank())
gr
dev.off();



pdf(paste(root_folder_of_result_graphs, "nb-semantic-patches.pdf", sep="/"),width=6, height=18, paper='special')
copying_kernel_time <- read.csv(paste(root_folder_of_csv_files, "nb-semantic-patches.csv", sep="/") , sep=";")
p<-ggplot(data=copying_kernel_time, aes(x=commit.id, y=nb.patches)) +
  geom_bar(stat="identity")
p