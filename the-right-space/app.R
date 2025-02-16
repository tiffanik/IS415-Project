#load packages
pacman::p_load(shiny,readxl, sf, tidyverse, tmap, sfdep,  ggpubr, plotly, sfdep, data.table, leaflet, shinyjs, shinyWidgets, bslib)
#library(shinythemes)

# import data
resale_sf<-readRDS("data/rds/resale_sf.rds")
mpsz_sf<-readRDS("data/rds/mpsz_sf.rds")
childcare_sf <- readRDS("data/rds/childcare_sf.rds")
eldercare_sf<- readRDS("data/rds/eldercare_sf.rds")
kindergartens_sf <- readRDS("data/rds/kindergartens_sf.rds")
hawkercentre_new_sf <- readRDS("data/rds/hawkercentre_new_sf.rds")
hawkercentre_healthy_sf<-readRDS("data/rds/hawkercentre_healthy_sf.rds")
nationalparks_sf<-readRDS("data/rds/nationalparks_sf.rds")
gyms_sf <-readRDS("data/rds/gyms_sf.rds")
pharmacy_sf<-readRDS("data/rds/pharmacy_sf.rds")
spf_sf<-readRDS("data/rds/spf_sf.rds")
HDB_carpark_sf<-readRDS("data/rds/HDB_carpark_sf.rds")
supermarket_sf<-readRDS("data/rds/supermarket_sf.rds")
bus_stop_sf<-readRDS("data/rds/bus_stop_sf.rds")
mrt_sf<-readRDS("data/rds/mrt_sf.rds")
primary_school_sf<-readRDS("data/rds/primary_school_sf.rds")
top10_primary_school_sf<-readRDS("data/rds/top10_primary_school_sf.rds")
shopping_mall_sf<-readRDS("data/rds/shopping_mall_sf.rds")
# combine street name and blk for HDB full address
resale_sf$full_address <- paste("BLK", resale_sf$block, resale_sf$street_name)
# based on visualisations, realised an area is placed wrongly (api gave wrong coordinates, thus, i removed it)
resale_sf_map<- subset(resale_sf, full_address != "BLK 27 MARINE CRES")

#---------------------------------------- NETWORK ANALYSIS DATA IMPORTATION
area_names <- c("MARINE PARADE", "BUKIT MERAH", "QUEENSTOWN","OUTRAM", "ROCHOR", "KALLANG","TANGLIN", "CLEMENTI", "BEDOK", "JURONG EAST", "GEYLANG", "BUKIT TIMAH","NOVENA", "TOA PAYOH","TUAS", "JURONG WEST","SERANGOON", "BISHAN","TAMPINES", "BUKIT BATOK","HOUGANG", "ANG MO KIO","PASIR RIS", "BUKIT PANJANG", "YISHUN", "PUNGGOL","CHOA CHU KANG", "SENGKANG","SEMBAWANG", "WOODLANDS")
area_names <- gsub(" ", "_", area_names)

setwd("data/rds/shape")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

setwd("../facilities/combined/childcare")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}
setwd("../../../lixel/childcare")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

setwd("../../facilities/combined/eldercare")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}
setwd("../../../lixel/eldercare")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

setwd("../../facilities/combined/hawker_new")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}
setwd("../../../lixel/hawker_new")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

setwd("../../facilities/combined/gym")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}
setwd("../../../lixel/gym")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

setwd("../../facilities/combined/hdb_carpark")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}
setwd("../../../lixel/hdb_carpark")
files <- list.files(pattern = ".rds")
for (file in files) {
  df_name <- sub(".rds", "", file)
  assign(df_name, readRDS(file))
}

# setwd("../../kfunc/childcare/multi")
# files <- list.files(pattern = ".rds")
# for (file in files) {
#   df_name <- sub(".rds", "", file)
#   assign(df_name, readRDS(file))
# }

#theme
my_theme <- bs_theme(
  version = 5,
  bootswatch = "minty",
  #navbar_color = "#5cb85c"
)

#UI
ui <- 
navbarPage(img(src="logo_t.png", style="float:right", width = "190px", height = "55px",),
  #"the right space", 
           collapsible = TRUE,
tabPanel("Home",
         fluidPage(
           theme = my_theme,
           #titlePanel("Enhancing HDB Buyer Decision-making: Spatial Point Pattern Analysis of Locations and Amenities"),
           
           # main with project description and motivation
           sidebarLayout(
             position = "right",
             sidebarPanel(
               div(style = "text-align: center;",
                   fluidRow(
                     column(6,  img(src='logo_t.png', align = "center", width = "190px", height = "55px", style = "display: block; margin: auto;")),
                     column(6, img(src='smu.png', align = "center", width = "130px", height = "55px", style = "display: block; margin: auto;"))
                   ),
                  
                   h6("Authors"),
                   p("This project is done by G1T7, Nguyen Mai Phuong, Kwang Kai Xuan Belle and Rhonda Ho Kah Yee"),
                   
                   h6("Acknowledgements"),
                   p("This project is done for IS415  Geospatial Analytics and Applications and we would like to thank Professor Kam Tin Seong for his guidance and resources."),
               ),
               #img(src='logo.PNG', align = "right"),
               
             ),
             
             # Main panel with analysis
             mainPanel(
               tags$head(
                 tags$style(
                   HTML("
        p {
          text-align: justify;
          text-justify: inter-word;
        }
      ")
                 )
               ),
               h2("Enhancing HDB Buyer Decision-making: Spatial Point Pattern Analysis of Locations and Amenities"),
               br(),
               img(src='istockphoto-466725040-170667a.jpg',width = "500px", height = "300px", align = "center", style = "display: block; margin: auto;"),
               h3("Our Motivation"),
               p("Many prospective HDB buyers face challenges in visualising and understanding the amenities and facilities available in the vicinity of their desired location. They often resort to manual searches on platforms like Google, which can be time-consuming and frustrating. Moreover, current mapping tools do not offer a comprehensive and tailored view of amenities specific to HDBs. Our motivation is to simplify this process by providing a user-friendly analytical app that enables HDB buyers to view and understand the surrounding amenities easily. Our app utilizes advanced spatial point pattern analysis techniques to visualize the distribution and clustering of amenities relevant to HDB buyers. By providing a customized view of amenities that cater specifically to the needs of HDB buyers, we aim to empower HDB buyers to make more informed decisions about their purchases and feel more confident in their chosen residence."),
               
               #h3("Our Objectives"),
               #p(" We aim to perform the following objectives:"),
               #p("1. Estimate the intensity of HDB locations and amenities across the study area using Kernel Density Estimation. 2. Determine whether the distribution of amenities around HDBs is random or clustered, and calculate the ratio of observed to expected nearest neighbor distances using F-Function analysis.
 #Measure the degree of clustering or dispersion of HDB locations and surrounding amenities using Ripley's K-function and L-function analysis.
 #Quantify the extent of spatial association and heterogeneity between HDB locations and surrounding amenities using Colocation Quotients (CLQs) analysis.
 #Conduct Network Constrained Spatial Point Patterns Analysis to analyze the spatial distribution of HDB flats over a street network.

#Overall, we aim to simplify the process for HDB buyers by providing them with a user-friendly app that visualizes the amenities and facilities in their desired location. By utilizing advanced spatial point pattern analysis techniques, we will identify significant spatial patterns and trends to help buyers make more informed decisions about their purchases and feel more confident in their chosen residence. Furthermore, the insights we gain will inform planning and policy decisions related to urban development and resource allocation.")
             )
           )
           
         )
         
         ),
tabPanel("Visualisation",
         fluidPage(
           #setBackgroundColor("#F5F5F5"),
           
           titlePanel("Mapping of HDB Locations and Relevant Amenities"),
           
           sidebarLayout(position = "right",
                         
                         sidebarPanel(
                           #style = "background-color:  #F9F9FF;",
                           p(id="","In this panel, you can adjust the visualisation of HDB locations with different amenities and adjust the price range of the HDB flat."),
                           selectInput("dataset_map", "What would like to view:",
                                       choices = c("Overview of HDB Locations", "HDB and Supermarkets")),
                           selectInput("price_range", "HDB Price Range:",
                                       choices = c("All","200,000 to 400,000", "400,000 to 600,000"))
                           #numericInput("price", "Observations:", 10)
                         ),
                         mainPanel(
                           #style = "background-color:  #F9F9FF;",
                           leafletOutput("map"),
                           p(id="note","Note: The map will take a while to load."),
                           
                           
                          )
                         )
             )
         ), #end bracket for visualisation tab
tabPanel("Spatial Point Pattern Analysis",
         fluidPage(
           tabsetPanel(
             tabPanel("CLQ"),
             tabPanel("KDE"),
             tabPanel("F-Function"),
             tabPanel("Ripley (K-Function)"),
             tabPanel("Network Constraint Analysis", fluidPage(
               sidebarLayout(
                 sidebarPanel(
                   h2("Variables"),
                   selectInput("net_areaName", label = h4("Area Name"), 
                               choices = area_names, 
                               selected = "ANG_MO_KIO"),
                   selectInput("net_facility", label = h4("Area Name"), 
                               choices = list("Childcare" = "childcare",
                                              "Eldercare" = "eldercare",
                                              "New Hawkers" = "hawker_new",
                                              "Gym" = "gym",
                                              "HDB Carparks" = "carpark"), 
                               selected = "Childcare"),
                 ),
                 mainPanel(
                   plotOutput("networkLixel"),
                   plotOutput("networkKFunc")
                 )
               )
             ))
             ))), 
#tabPanel("Dataset",
#         fluidPage(
           
#         )),
tabPanel("Data Upload",
         fluidPage(
           fileInput("upload", "Upload a file")
           #https://mastering-shiny.org/action-transfer.html
         ))
)


# Define server logic
server <- function(input, output) {
  
  delay(3000, hide("note"))
  
  m <- tm_shape(mpsz_sf) +
    tm_polygons("REGION_N", alpha = 0.2) +
    tm_shape(resale_sf_map) +
    tm_dots(col = "resale_price", 
            id = "full_address", 
            popup.vars = c("Resale Price:" = "resale_price",
                           "Flat Type:" = "flat_type", 
                           "Flat Model:" = "flat_model",
                           "Floor Area (sqm):" = "floor_area_sqm",
                           "Remaining Lease:" = "remaining_lease"
            ),
            title = "Resale Prices") +
    tm_view(set.zoom.limits = c(10, 14))
 
  # Convert tmap object to leaflet object
  leaflet_map <- tmap_leaflet(m)
  
  # Render leaflet map
  output$map <- renderLeaflet(leaflet_map)
  
  
  #NETWORK ANALYSIS
  output$networkLixel <- renderPlot(
    tm_shape(get(paste0("shape_", input$net_areaName))) +
      tm_polygons() +
      tm_shape(get(paste0("lixel_",input$net_facility, "_", input$net_areaName)))+
      tm_lines(col="density", lwd=2)+
      tm_shape(get(paste0("hdb_",input$net_facility, "_", input$net_areaName)))+
      tm_dots(col = "Point Type", palette=c('blue', 'red'))
  )
  # output$networkKFunc <- renderPlot(
  #   get(paste0("kfunc_", input$net_facility, "_", input$net_areaName))$plotk
  # )
}


# Run the application 
shinyApp(ui = ui, server = server)
