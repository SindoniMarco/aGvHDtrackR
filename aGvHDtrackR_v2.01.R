list_of_packages <- c("shiny", "bslib", "shinythemes", "periscope", "readxl", "writexl",
                      "grid", "gridExtra", "dplyr")
lapply(list_of_packages, 
       function(x) if(!require(x,character.only = TRUE)) install.packages(x))
library(shiny) 
library(bslib)
library(periscope)
library(shinythemes)
library(readxl)
library(writexl)
library(grid)
library(gridExtra)
library(dplyr)
dir <- getwd()
setwd(dir)
summary_table <- read_xlsx("Summary_Patient_acute_GvHD.xlsx")
previous_data <- length(summary_table$Name)
birth <- ifelse(previous_data > 0, summary_table$`Date of birth`[1], Sys.Date())
HSCT <- ifelse(previous_data > 0, summary_table$`Date HSCT`[1], Sys.Date())
ID <- if(previous_data > 0) {summary_table$`Patient ID`[1]}
treatment <- c("No CSA", "No MMF", "No mPDN", "No topical steroid", "No Ruxolitinib", "No ECP", "No Etanercept", 
               "No Infliximab", "No Abatacept", "No Begelomab", "No Sirolimus", "No mPDN Pulse", "No MSC",
               "No Azathioprine")
ui <- fluidPage(theme = shinytheme("cerulean"),
                titlePanel("aGvHDtrackR"),
                fluidRow(
                  column(3,
                         sidebarLayout(
                           sidebarPanel(width=12, id="sidebar1",
                                        h4("Patient general information"),
                                        textInput("Name", "Name", value = summary_table$Name[1]),
                                        textInput("Surname", "Surname", value = summary_table$Surname[1]),
                                        dateInput("DateBirth", "Date of birth",
                                                   value = birth),
                                        dateInput("DateHSCT", "Date of HSCT",
                                                   value = HSCT),
                                        textInput("ID", "Patient ID", value = ID)),
                           mainPanel(width = 0)
                           )
                         ),
                  column(3,
                         sidebarLayout(
                           sidebarPanel(width=12, id="sidebar2",
                                        h4("GvHD"),
                                        dateInput("Data", "Date of the assessment",
                                                  ),
                                        radioButtons("GvHD", "The patient has GvHD?", c("No", "Yes")),
                                        selectInput("Skin", "Percentage of skin covered by maculopapular rash", 
                                                    c("NA", "<25%", "25-50%", 
                                                      "Generalized erythroderma, >50%",
                                                      "Generalized erythroderma with bullae and desquamation")),
                                        selectInput("Liver", "Bilirubin (mg/dL)", c("NA", "<2 mg/dL",
                                                                                    "2.1-3 mg/dL",
                                                                                    "3.1-6 mg/dL",
                                                                                    "6.1-15 mg/dL",
                                                                                    ">15 mg/dL")),
                                        selectInput("Liver2", "Liver biopsy", c("NA","No signs of GvHD", "Mild", "Moderate", "Severe")),
                                        selectInput("LowerGI", "Quantity of diarrhea (mL)", c("NA", "<500 mL OR <10 mL/kg/die or <4 episodes/day",
                                                                                              "500-1000 mL OR 10-19 mL/kg/die or 4-6 episodes/day",
                                                                                              "1001-1500 mL OR 20-30 mL/kg/die or  7-10 episodes/day",
                                                                                              ">1500 mL OR OR >30 mL/kg/die or >10 episodes/day",
                                                                                              "Severe abdominal pain with and without ileus")),
                                        selectInput("UpperGI", "Upper GI symptoms", c("No or intermittent nausea, vomiting or anorexia", 
                                                                                      "Persistent nausea, vomiting or anorexia")),
                                        selectInput("GIupper_bio", "Upper GI biopsy", c("NA","No signs of GvHD", "Mild", "Moderate", "Severe")),
                                        selectInput("GIlower_bio", "Lower GI biopsy", c("NA","No signs of GvHD", "Mild", "Moderate", "Severe")),
                                        textInput("Weight", "Weight"),
                                        selectInput("CP", "Decrease in clinical performance", 
                                                    c("None", "Mild", "Marked", "Extreme"))),
                           mainPanel(width = 0)
                           )
                         ),
                  column(3,
                         sidebarLayout(
                           sidebarPanel(width=12, id="sidebar3",
                                        h4("Ongoing Therapy"),
                                        selectInput("input1", "Select Therapy", choices = c('',
                                                                                            'Cyclosporine',
                                                                                            'Mycophenolate Mofetil',
                                                                                            'Methylprednisolone',
                                                                                            'Topical steroid',
                                                                                            'Ruxolitinib',
                                                                                            'Extracorporeal photopheresis',
                                                                                            'Etanercept',
                                                                                            'Infliximab',
                                                                                            'Azathioprine',
                                                                                            'Abatacept',
                                                                                            'Begelomab',
                                                                                            'Sirolimus',
                                                                                            'mPDN Pulse',
                                                                                            'Mesenchymal Stromal Cell Therapy',
                                                                                            'Other treatments')),
                                        conditionalPanel(condition = "input.input1 == ''",
                                                         h5("No Therapy")),
                                        conditionalPanel("input.input1 == 'Cyclosporine'",
                                                         selectInput("CSA", "CSA treatment", 
                                                                      c("No CSA", "Full dose", "Tapering", "Stop CSA")),
                                                         dateInput("DateCSA", "Date start /change CSA"),
                                                         dateInput("DateCSAStop", "Date stop CSA"
                                                                    )),
                                        conditionalPanel("input.input1 == 'Mycophenolate Mofetil'",
                                                         selectInput("MMF", "MMF treatment", 
                                                                     c("No MMF", "Full dose", "Tapering", "Stop MMF")),
                                                         dateInput("DateMMF", "Date start /change MMF"
                                                                   ),
                                                         dateInput("DateMMFStop", "Date stop MMF"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Methylprednisolone'",
                                                         selectInput("mPDN", "mPDN treatment", 
                                                                     c("No mPDN", "1.8-2.5 mg/kg", "1.5-1.7 mg/kg", "1-1.4 mg/kg", "0.5-0.9 mg/kg", "<0.5 mg/kg", "Stop mPDN")),
                                                         dateInput("DatemPDN", "Date start / change mPDN"
                                                                   ),
                                                         dateInput("DatemPDNStop", "Date stop mPDN"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Topical steroid'",
                                                         selectInput("Steroid", "Topical steroid treatment", 
                                                                     c("No topical steroid", "Topical steroid", "Stop topical steroid")),
                                                         dateInput("DateSteroid", "Date start topical steroid"
                                                                   ),
                                                         dateInput("DateSteroidStop", "Date stop topical steroid"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Ruxolitinib'",
                                                         selectInput("Ruxo", "Ruxolitinib treatment", 
                                                                     c("No Ruxolitinib", "Full dose", "Tapering", "Stop Ruxolitinib")),
                                                         dateInput("DateRuxo", "Date start / change Ruxolitinib"
                                                                   ),
                                                         dateInput("DateRuxoStop", "Date stop Ruxolitinib"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Extracorporeal photopheresis'",
                                                         selectInput("ECP", "ECP treatment", 
                                                                     c("No ECP", "ECP", "Stop ECP")),
                                                         dateInput("DateECP", "Date start ECP"
                                                                   ),
                                                         dateInput("DateECPStop", "Date stop ECP"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Etanercept'",
                                                         selectInput("Etanercept", "Etanercept treatment", 
                                                                     c("No Etanercept", "Etanercept", "Stop Etanercept")),
                                                         dateInput("DateEtanercept", "Date start Etanercept"
                                                                   ),
                                                         dateInput("DateEtanerceptStop", "Date stop Etanercept"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Infliximab'",
                                                         selectInput("Infliximab", "Infliximab treatment", 
                                                                     c("No Infliximab", "Infliximab", "Stop Infliximab")),
                                                         dateInput("DateInfliximab", "Date start Infliximab"
                                                                   ),
                                                         dateInput("DateInfliximabStop", "Date stop Infliximab"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Azathioprine'",
                                                         selectInput("Azathioprine", "Azathioprine treatment", 
                                                                     c("No Azathioprine", "Azathioprine", "Stop Azathioprine")),
                                                         dateInput("DateAzathioprine", "Date start Azathioprine"
                                                                   ),
                                                         dateInput("DateAzathioprineStop", "Date stop Azathioprine"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Abatacept'",
                                                         selectInput("Abatacept", "Abatacept treatment", 
                                                                     c("No Abatacept", "Abatacept", "Stop Abatacept")),
                                                         dateInput("DateAbatacept", "Date start Abatacept"
                                                                   ),
                                                         dateInput("DateAbataceptStop", "Date stop Abatacept"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Begelomab'",
                                                         selectInput("Begelomab", "Begelomab treatment", 
                                                                     c("No Begelomab", "Begelomab", "Stop Begelomab")),
                                                         dateInput("DateBegelomab", "Date start Begelomab"
                                                                   ),
                                                         dateInput("DateBegelomabStop", "Date stop Begelomab"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Sirolimus'",
                                                         selectInput("Sirolimus", "Sirolimus treatment", 
                                                                     c("No Sirolimus", "Full dose", "Tapering", "Stop Sirolimus")),
                                                         dateInput("DateSirolimus", "Date start / change Sirolimus"
                                                                   ),
                                                         dateInput("DateSirolimusStop", "Date stop Sirolimus"
                                                                   )),
                                        conditionalPanel("input.input1 == 'mPDN Pulse'",
                                                         selectInput("Pulse", "mPDN Pulse treatment", 
                                                                     c("No mPDN Pulse", "mPDN Pulse", "Stop mPDN Pulse")),
                                                         dateInput("DatePulse", "Date start mPDN Pulse"
                                                                   ),
                                                         dateInput("DatePulseStop", "Date stop mPDN Pulse"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Mesenchymal Stromal Cell Therapy'",
                                                         selectInput("MSC", "MSC treatment", 
                                                                     c("No MSC", "MSC", "Stop MSC")),
                                                         dateInput("DateMSC", "Date start MSC"
                                                                   ),
                                                         dateInput("DateMSCStop", "Date stop MSC"
                                                                   )),
                                        conditionalPanel("input.input1 == 'Other treatments'",
                                                         textInput("Other", "Other treatment"),  
                                                         textInput("DateOther", "Date start Treatment"),
                                                         textInput("DrugOther", "Dose"),
                                                         textInput("DrugOtherStop", "Date stop Treatment"))),
                           mainPanel(width = 0)
                           )
                         ),
                  column(3,
                         sidebarLayout(
                           sidebarPanel(width=12, id="sidebar4",
                                        h4("Annotation for discontinuation of therapy"),
                                        textInput("Annotation", "Annotation")),
                           mainPanel (width = 0)
                         )
                  ),
                  column(8,
                         sidebarLayout(
                           sidebarPanel(width=12, id="sidebar6",
                                        h4("Body Surface Area"),
                                        img(src="repview.png", width = 1000, height = 500)
                           ),
                           mainPanel(width = 0)
                         )
                  )),
                  mainPanel(
                    downloadButton('download',"Download data"),
                    downloadButton('update',"Update Summary"),
                    downloadButton('report',"Download daily PDF report"),
                    
                    div(style = "height:80px"),
                    
                    tags$b(textOutput("title1")),
                    tableOutput("table1"),

                    div(style = "height:50px"),
                    
                    tags$b(textOutput("title2")),
                    tableOutput("table2"),
                    
                    div(style = "height:50px"),
                    
                    tags$b(textOutput("title3")),
                    tableOutput("table3"),
                    plotOutput("plot")
                  )
)
                   
server <- function(input, output, session) {
  data <- reactive({
    skin_stage <- ifelse(input$GvHD == "Yes" & input$Skin == "NA",0,
                         ifelse(input$GvHD == "Yes" & input$Skin == "<25%",1,
                                ifelse(input$GvHD == "Yes" & input$Skin == "25-50%",2,
                                       ifelse(input$GvHD == "Yes" & input$Skin == "Generalized erythroderma, >50%",3,
                                              ifelse(input$GvHD == "Yes" & input$Skin == "Generalized erythroderma with bullae and desquamation",4, 0)))))
    liver_stage <- ifelse(input$GvHD == "Yes" & input$Liver %in% c("NA", "<2 mg/dL"), 0,
                          ifelse(input$GvHD == "Yes" & input$Liver == "2.1-3 mg/dL", 1,
                                 ifelse(input$GvHD == "Yes" & input$Liver == "3.1-6 mg/dL", 2,
                                        ifelse(input$GvHD == "Yes" & input$Liver == "6.1-15 mg/dL", 3,
                                               ifelse(input$GvHD == "Yes" & input$Liver == ">15 mg/dL", 4,0)))))
    upper_GI_stage <- ifelse(input$GvHD == "Yes" & input$UpperGI == "No or intermittent nausea, vomiting or anorexia", 0,
                             ifelse(input$GvHD == "Yes" & input$UpperGI ==  "Persistent nausea, vomiting or anorexia", 1,0))
    
    lower_GI_stage <- ifelse(input$GvHD == "Yes" & input$LowerGI %in% c("NA", "<500 mL OR <10 mL/kg/die or <4 episodes/day"), 0,
                             ifelse(input$GvHD == "Yes" & input$LowerGI == "500-1000 mL OR 10-19 mL/kg/die or 4-6 episodes/day", 1,
                                    ifelse(input$GvHD == "Yes" & input$LowerGI == "1001-1500 mL OR 20-30 mL/kg/die or  7-10 episodes/day", 2,
                                           ifelse(input$GvHD == "Yes" & input$LowerGI == ">1500 mL OR OR >30 mL/kg/die or >10 episodes/day", 3,
                                                  ifelse(input$GvHD == "Yes" & input$LowerGI == "Severe abdominal pain with and without ileus",4,0)))))

    aGvHD_overall <- ifelse(input$GvHD == "No" & skin_stage == 0 & liver_stage == 0 & upper_GI_stage == 0 & lower_GI_stage == 0, "No GvHD",
                            ifelse(input$GvHD == "Yes" & skin_stage %in% c(1,2) & liver_stage == 0 & upper_GI_stage == 0 & lower_GI_stage == 0, "Grade I",
                                   ifelse(input$GvHD == "Yes" & skin_stage == 3 | liver_stage == 1 | upper_GI_stage == 1 | lower_GI_stage == 1, "Grade II",
                                          ifelse(input$GvHD == "Yes" &  liver_stage %in% c(2,3) | lower_GI_stage %in% c(2,3) & skin_stage !=4, "Grade III",
                                                 ifelse(input$GvHD == "Yes" & skin_stage == 4 | liver_stage == 4 | lower_GI_stage == 4, "Grade IV", "NA")))))
    daysinceHSCT <- difftime(input$Data, input$DateHSCT)
    N_metrics <- matrix(c(input$Name, input$Surname, as.character(input$DateBirth), as.character(input$DateHSCT), daysinceHSCT,input$ID, as.character(input$Data),
                          input$GvHD, aGvHD_overall,
                          input$Skin, skin_stage,
                          input$Liver, input$Liver2, liver_stage, 
                          input$LowerGI, input$GIlower_bio, lower_GI_stage,
                          input$UpperGI, input$GIupper_bio, upper_GI_stage,
                          input$Weight,
                          input$CP, 
                          input$CSA, as.character(input$DateCSA), as.character(input$DateCSAStop),
                          input$MMF, as.character(input$DateMMF), as.character(input$DateMMFStop),
                          input$mPDN, as.character(input$DatemPDN), as.character(input$DatemPDNStop),
                          input$Steroid, as.character(input$DateSteroid), as.character(input$DateSteroidStop),
                          input$Ruxo, as.character(input$DateRuxo), as.character(input$DateRuxoStop),
                          input$ECP, as.character(input$DateECP), as.character(input$DateECPStop),
                          input$Etanercept, as.character(input$DateEtanercept), as.character(input$DateEtanerceptStop),
                          input$Infliximab, as.character(input$DateInfliximab), as.character(input$DateInfliximabStop),
                          input$Azathioprine, as.character(input$DateAzathioprine), as.character(input$DateAzathioprineStop),
                          input$Abatacept, as.character(input$DateAbatacept), as.character(input$DateAbataceptStop),
                          input$Begelomab, as.character(input$DateBegelomab), as.character(input$DateBegelomabStop),
                          input$Sirolimus, as.character(input$DateSirolimus), as.character(input$DateSirolimusStop),
                          input$Pulse, as.character(input$DatePulse), as.character(input$DatePulseStop),
                          input$MSC, as.character(input$DateMSC), as.character(input$DateMSCStop),
                          input$Other, as.character(input$DateOther), input$DrugOther, input$DrugOtherStop,
                          input$Annotation), ncol = 69)
    N_metrics <- as.data.frame(N_metrics)
    colnames(N_metrics) <- c("Name",	"Surname", "Date of birth", "Date HSCT", "Days since HSCT","Patient ID", "Date of assessment",
                             "GvHD",	"aGvHD grading", 
                             "% of skin with maculopapular rash", "Skin stage",
                             "Bilirubin (mg/dL)",	"Liver biopsy", "Liver stage",
                             "Quantity of diarrhea (mL)",	"Lower GI biopsy", "Lower GI stage",
                             "Upper GI symptoms", "Upper GI biopsy", "Upper GI stage",
                             "Weight",
                             "Decrease in clinical performance",
                             "CSA treatment",	"Date starting / change CSA", "Date stop CSA",
                             "MMF treatment",	"Date starting / change MMF", "Date stop MMF",
                             "mPDN treatment",	"Date starting / change mPDN", "Date stop mPDN",
                             "Topical steroid treatment",	"Date starting topical steroid treatment", "Date stop topical steroid treatment",
                             "Ruxolitinib treatment",	"Date starting / change Ruxolitinib", "Date stop Ruxolitinib",
                             "ECP treatment",	"Date starting ECP", "Date stop ECP",
                             "Etanercept treatment",	"Date starting Etanercept", "Date stop Etanercept",
                             "Infliximab treatment",	"Date starting Infliximab", "Date stop Infliximab",
                             "Azathioprine treatment",	"Date starting Azathioprine", "Date stop Azathioprine",
                             "Abatacept treatment",	"Date starting Abatacept", "Date stop Abatacept",
                             "Begelomab treatment",	"Date starting Begelomab", "Date stop Begelomab",
                             "Sirolimus treatment",	"Date starting / change Sirolimus", "Date stop Sirolimus",
                             "Pulse treatment",	"Date starting Pulse", "Date stop Pulse",
                             "MSC treatment",	"Date starting MSC", "Date stop MSC",
                             "Other treatment",	"Date starting / change treatment", "Dose treatment", "Date stop treatment",
                             "Annotation for change/suspension of therapy")
    N_metrics["Date starting / change CSA"] <- ifelse(N_metrics["CSA treatment"] == "No CSA", "", N_metrics["Date starting / change CSA"])
    N_metrics["Date stop CSA"] <- ifelse(N_metrics["CSA treatment"] == "No CSA", "",
                                         ifelse(N_metrics["CSA treatment"] %in% c("Full dose", "Tapering"), "Ongoing", N_metrics["Date stop CSA"]))
    
    N_metrics["Date starting / change MMF"] <- ifelse(N_metrics["MMF treatment"] == "No MMF", "", N_metrics["Date starting / change MMF"])
    N_metrics["Date stop MMF"] <- ifelse(N_metrics["MMF treatment"] == "No MMF", "",
                                         ifelse(N_metrics["MMF treatment"] %in% c("Full dose", "Tapering"), "Ongoing", N_metrics["Date stop MMF"]))
    
    N_metrics["Date starting / change mPDN"] <- ifelse(N_metrics["mPDN treatment"] == "No mPDN", "", N_metrics["Date starting / change mPDN"])
    N_metrics["Date stop mPDN"] <- ifelse(N_metrics["mPDN treatment"] == "No mPDN", "", 
                                          ifelse(N_metrics["mPDN treatment"] %in% c("1.8-2.5 mg/kg", "1.5-1.7 mg/kg", "1-1.4 mg/kg", "0.5-0.9 mg/kg", "<0.5 mg/kg"), "Ongoing",N_metrics["Date stop mPDN"]))
    
    N_metrics["Date starting topical steroid treatment"] <- ifelse(N_metrics["Topical steroid treatment"] == "No topical steroid", "",N_metrics["Date starting topical steroid treatment"])
    N_metrics["Date stop topical steroid treatment"] <- ifelse(N_metrics["Topical steroid treatment"] == "No topical steroid","",
                                                             ifelse(N_metrics["Topical steroid treatment"] == "Topical steroid", "Ongoing", N_metrics["Date stop topical steroid treatment"]))
    
    N_metrics["Date starting / change Ruxolitinib"] <- ifelse(N_metrics["Ruxolitinib treatment"] == "No Ruxolitinib", "", N_metrics["Date starting / change Ruxolitinib"])
    N_metrics["Date stop Ruxolitinib"] <- ifelse(N_metrics["Ruxolitinib treatment"] == "No Ruxolitinib", "",
                                                 ifelse(N_metrics["Ruxolitinib treatment"] %in% c("Full dose", "Tapering"), "Ongoing", N_metrics["Date stop Ruxolitinib"]))
    
    N_metrics["Date starting ECP"] <- ifelse(N_metrics["ECP treatment"] == "No ECP","", N_metrics["Date starting ECP"])
    N_metrics["Date stop ECP"] <- ifelse(N_metrics["ECP treatment"] == "No ECP", "",
                                         ifelse(N_metrics["ECP treatment"] == "ECP", "Ongoing", N_metrics["Date stop ECP"]))
    
    N_metrics["Date starting Etanercept"] <- ifelse(N_metrics["Etanercept treatment"] == "No Etanercept", "", N_metrics["Date starting Etanercept"])
    N_metrics["Date stop Etanercept"] <- ifelse(N_metrics["Etanercept treatment"] == "No Etanercept","",
                                                ifelse(N_metrics["Etanercept treatment"] == "Etanercept", "Ongoing", N_metrics["Date stop Etanercept"]))
    
    N_metrics["Date starting Infliximab"] <- ifelse(N_metrics["Infliximab treatment"] == "No Infliximab", "", N_metrics["Date starting Infliximab"])
    N_metrics["Date stop Infliximab"] <- ifelse(N_metrics["Infliximab treatment"] == "No Infliximab", "",
                                                ifelse(N_metrics["Infliximab treatment"] == "Infliximab", "Ongoing", N_metrics["Date stop Infliximab"]))
    N_metrics["Date starting Azathioprine"] <- ifelse(N_metrics["Azathioprine treatment"] == "No Azathioprine","", N_metrics["Date starting Azathioprine"])
    N_metrics["Date stop Azathioprine"] <- ifelse(N_metrics["Azathioprine treatment"] == "No Azathioprine", "",
                                               ifelse(N_metrics["Azathioprine treatment"] == "Azathioprine", "Ongoing", N_metrics["Date stop Azathioprine"]))
    N_metrics["Date starting Abatacept"] <- ifelse(N_metrics["Abatacept treatment"] == "No Abatacept","", N_metrics["Date starting Abatacept"])
    N_metrics["Date stop Abatacept"] <- ifelse(N_metrics["Abatacept treatment"] == "No Abatacept", "",
                                               ifelse(N_metrics["Abatacept treatment"] == "Abatacept", "Ongoing", N_metrics["Date stop Abatacept"]))
    
    N_metrics["Date starting Begelomab"] <- ifelse(N_metrics["Begelomab treatment"] == "No Begelomab", "", N_metrics["Date starting Begelomab"])
    N_metrics["Date stop Begelomab"] <- ifelse(N_metrics["Begelomab treatment"] == "No Begelomab","",
                                               ifelse(N_metrics["Begelomab treatment"] == "Begelomab", "Ongoing", N_metrics["Date stop Begelomab"]))
    
    N_metrics["Date starting / change Sirolimus"] <- ifelse(N_metrics["Sirolimus treatment"] == "No Sirolimus","", N_metrics["Date starting / change Sirolimus"])
    N_metrics["Date stop Sirolimus"] <- ifelse(N_metrics["Sirolimus treatment"] == "No Sirolimus", "",
                                               ifelse(N_metrics["Sirolimus treatment"] %in% c("Full dose", "Tapering"), "Ongoing", N_metrics["Date stop Sirolimus"]))
    
    N_metrics["Date starting Pulse"] <- ifelse(N_metrics["Pulse treatment"] == "No mPDN Pulse", "", N_metrics["Date starting Pulse"])
    N_metrics["Date stop Pulse"] <- ifelse(N_metrics["Pulse treatment"] == "No mPDN Pulse", "",
                                           ifelse(N_metrics["Pulse treatment"] == "mPDN Pulse", "Ongoing", N_metrics["Date stop Pulse"]))
    
    N_metrics["Date starting MSC"] <- ifelse(N_metrics["MSC treatment"] == "No MSC", "", N_metrics["Date starting MSC"])
    N_metrics["Date stop MSC"] <- ifelse(N_metrics["MSC treatment"] == "No MSC", "", 
                                         ifelse(N_metrics["MSC treatment"] == "MSC", "Ongoing", N_metrics["Date stop MSC"]))
    
    if(length(summary_table$Name) > 0){
      index <- length(summary_table[,1])
      N_metrics[1,c(1:4,6)] <- summary_table[index,c(1:4,6)]
      if(N_metrics[1,23] == summary_table[index,23]){
        N_metrics[1,24] <- summary_table[index,24]
      }
      if(N_metrics[1,26] == summary_table[index,26]){
        N_metrics[1,27] <- summary_table[index,27]
      }
      if(N_metrics[1,29] == summary_table[index,29]){
        N_metrics[1,30] <- summary_table[index,30]
      }
      if(N_metrics[1,32] == summary_table[index,32]){
        N_metrics[1,33] <- summary_table[index,33]
      }
      if(N_metrics[1,35] == summary_table[index,35]){
        N_metrics[1,36] <- summary_table[index,36]
      }
      if(N_metrics[1,38] == summary_table[index,38]){
        N_metrics[1,39] <- summary_table[index,39]
      }
      if(N_metrics[1,41] == summary_table[index,41]){
        N_metrics[1,42] <- summary_table[index,42]
      }
      if(N_metrics[1,44] == summary_table[index,44]){
        N_metrics[1,45] <- summary_table[index,45]
      }
      if(N_metrics[1,47] == summary_table[index,47]){
        N_metrics[1,48] <- summary_table[index,48]
      }
      if(N_metrics[1,50] == summary_table[index,50]){
        N_metrics[1,51] <- summary_table[index,51]
      }
      if(N_metrics[1,53] == summary_table[index,53]){
        N_metrics[1,54] <- summary_table[index,54]
      }
      if(N_metrics[1,56] == summary_table[index,56]){
        N_metrics[1,57] <- summary_table[index,57]
      }
      if(N_metrics[1,59] == summary_table[index,59]){
        N_metrics[1,60] <- summary_table[index,60]
      }
      if(N_metrics[1,62] == summary_table[index,62]){
        N_metrics[1,63] <- summary_table[index,63]
      }
      N_metrics[,5] <- round((difftime(as.character(as.Date(N_metrics[,7])),
                                       as.Date(as.character(summary_table[index,4])))),
                             digits = 0)
    }
    N_metrics
  })
  
  output$title1 <- renderText("Today assessment")
  output$table1 <- renderTable({
    data() %>% 
      select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
      select(where(~ !all(. %in% treatment)))
  })
  
  output$title2 <- renderText("Latest assessment")
  output$table2 <- if(length(summary_table$Name) >0) {renderTable({
    summary_table[length(summary_table$Name),] %>%
      select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
      select(where(~ !all(. %in% treatment)))
  })} else{renderText({"No previous determination"})}
  
  output$title3 <- renderText("Worst assessment")
  output$table3 <- if(length(summary_table$Name) == 0){
    renderText({"No previous determination"})}
  else{
    index_grade_scoring <- which(summary_table$`aGvHD grading` %in% "Grade IV")
    if(length(index_grade_scoring) != 0) {
      renderTable({
        summary_table[max(index_grade_scoring),] %>%
          select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
          select(where(~ !all(. %in% treatment)))
      })} 
    else{
      index_grade_scoring <- which(summary_table$`aGvHD grading` %in% "Grade III")
      if(length(index_grade_scoring) != 0) {
    renderTable({
      summary_table[max(index_grade_scoring),] %>%
        select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
        select(where(~ !all(. %in% treatment)))
    })}
      else{
        index_grade_scoring <- which(summary_table$`aGvHD grading` %in% "Grade II")
        if(length(index_grade_scoring) != 0) {
      renderTable({
        summary_table[max(index_grade_scoring),] %>%
          select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
          select(where(~ !all(. %in% treatment)))
      })}
        else{
          index_grade_scoring <- which(summary_table$`aGvHD grading` %in% "Grade I")
          if(length(index_grade_scoring) != 0) {
            renderTable({
              summary_table[max(index_grade_scoring),] %>%
                select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
                select(where(~ !all(. %in% treatment)))
            })}
          else{renderText({"No previous determination"})}
    }
  }
}
}
    
    
    
  
  output$download <- downloadHandler(
    filename = function(){paste0(as.character(input$Data),"_", input$Surname,"_", input$Name, ".xlsx")}, 
    content = function(fname){
      write_xlsx(data(), fname)}
  )
  
  output$update <- downloadHandler(
    filename = function(){"Summary_Patient_acute_GvHD.xlsx"}, 
    content = function(fname){
      database <- as.data.frame(read_excel("Summary_Patient_acute_GvHD.xlsx"))
      Data <- rbind(database, data()) 
      write_xlsx(x = Data, fname)
      output$table <- renderTable({
        summary_table
      })
    })
  
  output$report = downloadHandler(
    filename = function() {paste0("report_aGvHD ", input$Data, ".pdf")},
    content = function(file) {
      pdf(file = file, height = 8, width = 13)
      tabella <- data()[,c(22:62)] %>%
        select(where(~ !(all(is.na(.)) | all(. == "")))) %>%
        select(where(~ !all(. %in% treatment)))
      tabella1 <- tableGrob(data()[,c(1:7)], rows = "")
      tabella2 <- tableGrob(t(data()[,c(8:21)]))
      if(length(tabella) > 0){
        tabella3 <- tableGrob(t(tabella))
      } else{tabella3 <- tableGrob("No Therapy ongoing")}
      
      grid.arrange(arrangeGrob(tabella1, tabella2, nrow = 2, ncol = 1),
                   arrangeGrob(tabella3, nrow = 1, ncol = 1), widths=c(2,1), heights = c(1,0))
      dev.off()
    }
  )
}
shinyApp(ui = ui, server = server)
