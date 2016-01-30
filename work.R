#read the data
dat<-read.csv("~/Downloads/pml-training.csv")

#Ongoing activities
dat2<-dat[dat$new_window=='no',]

#only the data we are interested in
dat3<-subset(dat2,select = c(roll_belt,pitch_belt,yaw_belt,total_accel_belt,gyros_belt_x,gyros_belt_y,gyros_belt_z,accel_belt_x,accel_belt_y,accel_belt_z,magnet_belt_x,magnet_belt_y,magnet_belt_z,roll_arm,pitch_arm,yaw_arm,total_accel_arm,gyros_arm_x,gyros_arm_y,gyros_arm_z,accel_arm_x,accel_arm_y,accel_arm_z,magnet_arm_x,magnet_arm_y,magnet_arm_z,roll_dumbbell,pitch_dumbbell,yaw_dumbbell,classe))

set.seed(12345)
library(caret)
inWork<-createDataPartition(y=dat3$classe,p=0.7,list=FALSE)
working<-dat3[inWork,]
testing<-dat3[-inWork,]



