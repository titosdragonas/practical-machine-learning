# Activity recognition using classification algorithms
Titos Dragonas  
January 29, 2016  


##Summary
Human activity recognition is an important research area that has been gaining traction over the past years as the availability of wearable/portable accelerometers has increased.  This creates the possibility of context aware applications that change their behaviour when the user is performing different activities such as walking or driving.  The Pontificial Catholic University of Rio de Janeiro hosts a dataset of measurements of different accelerometers attached to six individuals performing five different activities: sitting-down, standing-up, standing, walking, and sitting.  The goal of this project is to train one or more algorithms to recognize the activity type by the measurements.  As a final test, the algorithm is to be evaluated with a set of 20 entries where the outcome is hidden from the student.

##Data exploration and pruning

After a quick glance over both data sets (training & test) it becomes obvious that the test data is not in a timeseries format, i.e. we will have to create our model using discrete instances of measurements.  Another thing that ended up being important was that the features new_window and num_window refered to the event of starting a new measurement series and the reference to it.  Since the test set is not continuous I think it will be safe to discard those too.  Finally, the features with averages, stddevs and other aggregate measurements are only present when a window is starting so we will discard those features too.  The only features that we will use are the ones that have values when new_window is 'no' and of course, the 'classe' variable which indicates the type of activity.


```r
dat<-read.csv("~/Downloads/pml-training.csv")
dat2<-dat2<-dat[dat$new_window=='no',]
dat3<-subset(dat2,select = c(roll_belt,pitch_belt,yaw_belt,total_accel_belt,gyros_belt_x,gyros_belt_y,gyros_belt_z,accel_belt_x,accel_belt_y,accel_belt_z,magnet_belt_x,magnet_belt_y,magnet_belt_z,roll_arm,pitch_arm,yaw_arm,total_accel_arm,gyros_arm_x,gyros_arm_y,gyros_arm_z,accel_arm_x,accel_arm_y,accel_arm_z,magnet_arm_x,magnet_arm_y,magnet_arm_z,roll_dumbbell,pitch_dumbbell,yaw_dumbbell,classe))
```

##Splitting the data for validation
Since we are expected to pick the best algorighm we will need to keep a subset of our training data for validation.  Fortunately the number of entries is high enough to not need sophisticated cross validation mechanisms.  In this case I used 30% of the data as validation, and split the rest in three equal parts (and each into their respective train/test subsets, with substitution) to train each of the  algorithms.  The following code performs the splitting:


```r
set.seed(12345)
library(caret)
inWork<-createDataPartition(y=dat3$classe,p=0.7,list=FALSE)
working<-dat3[inWork,]
testing<-dat3[-inWork,]

inSet1<-createDataPartition(y=working$classe,p=2/3,list=FALSE)
inSet2<-createDataPartition(y=working$classe,p=2/3,list=FALSE)
inSet3<-createDataPartition(y=working$classe,p=2/3,list=FALSE)

trains1<-working[inSet1,]
tests1<-working[-inSet1,]
trains2<-working[inSet2,]
tests2<-working[-inSet2,]
trains3<-working[inSet3,]
tests3<-working[-inSet3,]
```

##Algorithms and training
The algorithms I picked for this excercise are Naive Bayes, Random Forests and Support Vector Machines.  Naive Bayes establishes a good 'baseline' for machine learning problems while SVM and RF are two of the common machine learning algorithms in use currently.  A small note, the caret train function took way too long (hours) when using the default values on the computer I have available at the moment, so I had to either dive into the trainControl object to understand it properly or use the native implementation of each algorithm (which is what I ended up doing).  The three method names for the three algorithms as they need to be supplied to train are: nb, rf and svmLinear2.  A good resource for the list of possible models within caret is https://topepo.github.io/caret/modelList.html

The following code creates the three models and their prediction vectors:


```r
library(e1071)
library(randomForest)

mod.nb<-naiveBayes(classe~.,data=trains1)
mod.rf<-randomForest(classe~.,data=trains2)
mod.svm<-svm(classe~.,data=trains3)

pred.nb<-predict(mod.nb,tests1)
pred.rf<-predict(mod.rf,tests2)
pred.svm<-predict(mod.svm,tests3)
```
###Picking a winner and estimating the out of sample error
We create the confusion matrices for each test


```r
cm.nb<-confusionMatrix(tests1$classe,pred.nb)
cm.rf<-confusionMatrix(tests2$classe,pred.rf)
cm.svm<-confusionMatrix(tests3$classe,pred.svm)
```

And report each algorithm's accuracy

|Classifier|Accuracy|
|---|---|
| Naive Bayes | 46.90% |
|Random Forest|97.37%|
|Support Vector Machine|81.77%|

Random Forest looks like the best fit to the training data, let's validate:


```r
library(e1071)
library(randomForest)
pred.testing<-predict(mod.rf,testing)
cm.testing<-confusionMatrix(testing$classe,pred.testing)
paste0(formatC(100*cm.testing$overall['Accuracy'],digits=2,format="f"),"%")
```

```
## [1] "97.28%"
```

The expected out of sample error is close to 3%, So I expect 19/20 against the real test set.

##Performance on Test set
The random forest model obtained 20/20 on the real test set.
