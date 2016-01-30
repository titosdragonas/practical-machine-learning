---
title: "Activity recognition using classification algorithms"
author: "Titos Dragonas"
date: "January 29, 2016"
output: html_document
---

```{r setup, echo=FALSE}
  library(knitr)
```
##Summary
Human activity recognition is an important research area that has been gaining traction over the past years as the availability of wearable/portable accelerometers has increased.  This creates the possibility of context aware applications that change their behaviour when the user is performing different activities such as walking or driving.  The Pontificial Catholic University of Rio de Janeiro hosts a dataset of measurements of different accelerometers attached to six individuals performing five different activities: sitting-down, standing-up, standing, walking, and sitting.  The goal of this project is to train one or more algorithms to recognize the activity type by the measurements.  As a final test, the algorithm is to be evaluated with a set of 20 entries where the outcome is hidden from the student.

##Data exploration and pruning

After a quick glance over both data sets (training & test) it becomes obvious that the test data is not in a timeseries format, i.e. we will have to create our model using discrete instances of measurements.  Another thing that ended up being important was that the features new__window and num__window 

```{r cache=TRUE}
dat<-read.csv("~/Downloads/pml-training.csv")
dat2<-dat2<-dat[dat$new_window=='no',]
dat3<-subset(dat2,select = c(roll_belt,pitch_belt,yaw_belt,total_accel_belt,gyros_belt_x,gyros_belt_y,gyros_belt_z,accel_belt_x,accel_belt_y,accel_belt_z,magnet_belt_x,magnet_belt_y,magnet_belt_z,roll_arm,pitch_arm,yaw_arm,total_accel_arm,gyros_arm_x,gyros_arm_y,gyros_arm_z,accel_arm_x,accel_arm_y,accel_arm_z,magnet_arm_x,magnet_arm_y,magnet_arm_z,roll_dumbbell,pitch_dumbbell,yaw_dumbbell,classe))

```

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
