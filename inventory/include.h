#ifndef INCLUDE_H
#define INCLUDE_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtAndroidExtras>

#include "enhancedqmlapplicationengine.h"
#include "tablemodel.h"
#include "inventorytablemodel.h"
#include "shippingtablemodel.h"
#include "database.h"
#include "logintablemodel.h"
#include "customuser.h"


void AndroidBatteryStateChanged(JNIEnv *env, jobject thiz, jint level, jboolean onCharge);
void InitializeForAndroidBattery();
void AndroidSystemInformation(JNIEnv *env, jobject thiz, jstring body);
void InitializeForAndroidInformation();
void ConfirmMessageDlg(QString title,QString content);



#endif // INCLUDE_H
