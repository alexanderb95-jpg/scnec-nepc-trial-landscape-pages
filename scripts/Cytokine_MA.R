library(metafor)
library (ggplot2)
library(meta)
library(dplyr)
setwd("/Users/Alex/R")

#Load data
CRPmetaOS <- read.csv("CRPresponse_Metareg1.csv")
IL8metaPFS <- read.csv("IL8predictivePFS_Metareg.csv")
IL6metaPFS <-read.csv("IL6predictivePFS_Metareg.csv")
IL6metaOS <- read.csv("IL6predictive_Metareg.csv")
IL8metaOS <-read.csv("IL8predictive_Metareg.csv")
cytokinefunnel <- read.csv("cytokinefunnel.csv")

#Random effects model
m.gencrp <- metagen (TE= LogHR_OS, seTE=SE_OS, studlab=Study_ID, data = CRPmetaOS, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
m.genIL8OS <- metagen (TE= LogHR_OS, seTE=SE_OS, studlab=Study_ID, data = IL8metaOS, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
m.genIL6OS <- metagen (TE= LogHR_OS, seTE=SE_OS, studlab=Study_ID, data = IL6metaOS, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
m.genIL6PFS <- metagen (TE= LogHR_PFS, seTE=SE_PFS, studlab=Study_ID, data = IL6metaPFS, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
m.genIL8PFS <- metagen (TE= LogHR_PFS, seTE=SE_PFS, studlab=Study_ID, data = IL8metaPFS, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")

m.cytokinefunnel <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = cytokinefunnel, sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of cytokine on HR/ORR")

##Funnel plots

#CRP_OS
m.gen.funnelCRPOS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "CRP", Outcome=="OS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
CRPOSfunnelplot <- funnel(m.gen.funnelCRPOS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "CRP OS")

#CRP_PFS
m.gen.funnelCRPPFS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "CRP", Outcome=="PFS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
CRPPFSfunnelplot <- funnel(m.gen.funnelCRPPFS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "CRP PFS")


#CRP_ORR
m.gen.funnelCRPORR <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "CRP", Outcome=="ORR"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
CRPORRfunnelplot <- funnel(m.gen.funnelCRPORR, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(OR)")
title(main = "CRP ORR")



#IL-6_OS
m.gen.funnelIL6OS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-6", Outcome=="OS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL6OSfunnelplot <- funnel(m.gen.funnelIL6OS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "IL-6 OS")

#IL-6_PFS
m.gen.funnelIL6PFS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-6", Outcome=="PFS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL6PFSfunnelplot <- funnel(m.gen.funnelIL6PFS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "IL-6 PFS")


#IL-6_ORR
m.gen.funnelIL6ORR <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-6", Outcome=="ORR"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL6ORRfunnelplot <- funnel(m.gen.funnelIL6ORR, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(OR)")
title(main = "IL-6 ORR")


#IL-8_OS
m.gen.funnelIL8OS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-8", Outcome=="OS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL8OSfunnelplot <- funnel(m.gen.funnelIL8OS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "IL-8 OS")


#IL-8_PFS
m.gen.funnelIL8PFS <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-8", Outcome=="PFS"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL8PFSfunnelplot <- funnel(m.gen.funnelIL8PFS, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(HR)")
title(main = "IL-8 PFS")

#IL-8_ORR
m.gen.funnelIL8ORR <- metagen (TE= LogHR, seTE=SE, studlab=Study_ID, data = filter(cytokinefunnel, Cytokine== "IL-8", Outcome=="ORR"), sm= "SMD", fixed= FALSE, random = TRUE, method.tau = "REML", hakn = TRUE, title = "Effect of CRP Response on OS")
IL8ORRfunnelplot <- funnel(m.gen.funnelIL8ORR, level = 0.95, outline = FALSE,  col = "lightgray", xlab="log(OR)")
title(main = "IL-8 ORR")



##Eggers test
CRP.meta.OS.eggger <-metabias(m.gen.funnelCRPOS, k.min=6)
CRP.meta.PFS.eggger <-metabias(m.gen.funnelCRPPFS, k.min=6)
CRP.meta.ORR.eggger <-metabias(m.gen.funnelCRPORR, k.min=6)
IL6.meta.OS.eggger <-metabias(m.gen.funnelIL6OS, k.min=6)
IL6.meta.PFS.eggger <-metabias(m.gen.funnelIL6PFS, k.min=6)
IL6.meta.ORR.eggger <-metabias(m.gen.funnelIL6ORR, k.min=3)
IL8.meta.OS.eggger <-metabias(m.gen.funnelIL8OS, k.min=6)
IL8.meta.PFS.eggger <-metabias(m.gen.funnelIL8PFS, k.min=6)
IL8.meta.ORR.eggger <-metabias(m.gen.funnelIL8ORR, k.min=6)


##Meta-regression
crpmetareg <- metareg (m.gencrp, CRP_Cutoff_mgdL) 
CRP.meta.OS.MRG <- bubble(crpmetareg, studlab = FALSE, ylim=c(-3,0), xlim=c(0,2), xlab="CRP cutoff (mg/dL)", ylab="Log hazard ratio")

IL6metaregOS <- metareg (m.genIL6OS, IL6_Cutoff_pgmL) 
IL6.meta.OS.MRG <- bubble(IL6metaregOS, studlab = FALSE, ylim=c(-1,0), xlim=c(0,20), xlab="IL-6 cutoff (pg/mL)", ylab="Log hazard ratio")

IL6metaregPFS <- metareg (m.genIL6PFS, IL6_Cutoff_pgmL) 
IL6.meta.PFS.MRG <- bubble(IL6metaregPFS, studlab = FALSE, ylim=c(-1,0), xlim=c(0,20), xlab="IL-6 cutoff (pg/mL)", ylab="Log hazard ratio")

IL8metaregOS <- metareg (m.genIL8OS, IL8_Cutoff_pgmL) 
IL8.meta.OS.MRG <- bubble(IL8metaregOS, studlab = FALSE, ylim=c(-1,0), xlim=c(0,40), xlab="IL-8 cutoff (pg/mL)", ylab="Log hazard ratio")

IL8metaregPFS <- metareg (m.genIL8PFS, IL8_Cutoff_pgmL) 
IL8.meta.PFS.MRG <- bubble(IL8metaregPFS, studlab = FALSE, ylim=c(-1,0), xlim=c(0,40), xlab="IL-8 cutoff (pg/mL)", ylab="Log hazard ratio")


