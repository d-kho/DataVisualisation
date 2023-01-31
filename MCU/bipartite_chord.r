library(chorddiag)
library(RColorBrewer)
library(igraph)
library(ggplot2)
library(circlize)
library(network)
library(htmlwidgets)
g <- read_graph('marvel-graph.graphml', format = 'graphml')
g.matrix <- as_adjacency_matrix(g) %>% as.matrix()
g.matrix.bip <-g.matrix[1:28,29:52]

#Generate a list of unique colours
qual_col_pals <- brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector <- unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
set.seed(1)
colours <- sample(col_vector, 52)


chord <- chorddiag(g.matrix.bip, type = 'bipartite',
          categoryNames = c("Movie", "Hero"),
          categorynamePadding = 350,
          # height = 750,
          # width = 750,
          margin = 200,
          categorynameFontsize = 14,
          showTicks = FALSE, showGroupnames = TRUE,
          groupColors = colours)


saveWidget(chord, file="chord_interactive.html")
