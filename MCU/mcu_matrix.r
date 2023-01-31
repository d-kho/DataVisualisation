library(igraph)
library(dplyr)
library(ggplot2)
library(networkD3)

g <- read.graph("marvel-graph.graphml.xml", format = c("graphml"))
write_graph(g, file = 'marvel.gml',format = 'gml')

sankeyNetwork(Links = E(g), Nodes = V(g), Source = "source",
              Target = "target", NodeID = "name",
              fontSize = 12, nodeWidth = 30)

?sankeyNetwork


dupes <- which(duplicated(vertex.attributes(g)$name))
V(g)[dupes]$name <- paste0(V(g)[dupes]$name, "(Movie)")

node_list <- get.data.frame(g, what = 'vertices')
edge_list <- get.data.frame(g, what = 'edges') 


all_nodes <- sort(node_list$name)

movie_nodes<- edge_list

plot_data <- edge_list %>% mutate(to = factor(to, levels = all_nodes),
                                  from = factor(from, levels = all_nodes))
ggplot(plot_data, aes(x = from, y = to)) +
  geom_raster() +
  theme_bw() +
  scale_x_discrete() +
  scale_y_discrete()+
  theme(
    # Rotate the x-axis lables so they are legible
    axis.text.x = element_text(angle = 270, hjust = 0),
    # Force the plot into a square aspect ratio
    aspect.ratio = 1,
    # Hide the legend (optional)
    legend.position = "none") + coord_fixed()

library(RColorBrewer)
library(dendextend)
library(heatmaply)
row.col <-brewer.pal(11, "RdYlGn")
row.dend <- plot_data %>% dist() %>% hclust() %>% as.dendrogram() %>% set("branches_k_color", row.col, k = 11)
no.colour <- rgb(233, 236, 239, max = 255)
yes.colour <- rgb(255, 183, 3, max = 255)
  netmatrix <- get.adjacency(g) %>% as.matrix()
heatmaply(netmatrix[1:28, 29:52], grid_gap = 0.2,
          colors = c(no.colour, yes.colour),
          label_names = c("Character", "Movie", "Value"),
          k_col = 4, k_row = 8, branches_lwd = 0.3,
          dend_hoverinfo = FALSE,hide_colorbar = TRUE,
          main = "Marvel Cinematic Universe Character Appearances"
          )
?geom_tile
?heatmaply
