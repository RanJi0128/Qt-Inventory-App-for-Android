
#include "include.h"

static QObject *pQmlRootObject = nullptr;

void AndroidBatteryStateChanged(JNIEnv *env, jobject thiz, jint level, jboolean onCharge)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)

    if(pQmlRootObject != nullptr)
    {
        QMetaObject::invokeMethod(pQmlRootObject,"androidBatteryStateChanged" ,Qt::AutoConnection, Q_ARG(QVariant, level),Q_ARG(QVariant, onCharge));
    }

}

void InitializeForAndroidBattery()
{

    JNINativeMethod methods[] = {

            {  "BatteryStateChanged","(IZ)V",reinterpret_cast<void*>(AndroidBatteryStateChanged) }
        };

    QAndroidJniObject batteryLevel_j("com/jni/systeminfo/BatteryLevelListener");

    QAndroidJniEnvironment env;

    jclass objectClass = env->GetObjectClass(batteryLevel_j.object<jobject>());

    env->RegisterNatives(objectClass,methods,sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);

   // batteryLevel_j.callMethod<void>("InstallBatteryListener");
    QAndroidJniObject::callStaticMethod<void>("com/jni/systeminfo/BatteryLevelListener", "InstallBatteryListener");

}

void AndroidSystemInformation(JNIEnv *env, jobject thiz, jstring body)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)

    if(pQmlRootObject != nullptr)
    {
        QAndroidJniObject string = body;
        QString qstring = string.toString();

        QMetaObject::invokeMethod(pQmlRootObject,"androidSystemInformation" ,Qt::AutoConnection, Q_ARG(QVariant, qstring));
    }

}
void InitializeForAndroidInformation()
{
    JNINativeMethod methods[] = {

            {  "SystemInformation","(Ljava/lang/String;)V",reinterpret_cast<void*>(AndroidSystemInformation) }
        };
     QAndroidJniObject sysInfor_j("com/jni/systeminfo/DeviceInformation");

     QAndroidJniEnvironment env;

     jclass objectClass = env->GetObjectClass(sysInfor_j.object<jobject>());

     env->RegisterNatives(objectClass,methods,sizeof(methods) / sizeof(methods[0]));
     env->DeleteLocalRef(objectClass);


     QAndroidJniObject::callStaticMethod<void>("com/jni/systeminfo/DeviceInformation", "sendInformation","(Landroid/content/Context;)V",
                                               QtAndroid::androidContext().object<jobject>());
}
void ConfirmMessageDlg(QString title,QString content)
{

    if(pQmlRootObject != nullptr)
    {
        QMetaObject::invokeMethod(pQmlRootObject,"confirmMessageDlg" ,Qt::AutoConnection, Q_ARG(QVariant, title),Q_ARG(QVariant, content));
    }

}
int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    //qmlRegisterType<TableModel>("TableModel", 0, 1, "TableModel");

    EnhancedQmlApplicationEngine engine;

    DataBase database;
    database.connectToDataBase();
    engine.rootContext()->setContextProperty("db_model", &database);

    LoginTableModel loginmodel ;
    engine.rootContext()->setContextProperty("login_model", &loginmodel);

    TableModel model;
    engine.rootContext()->setContextProperty("table_model", &model);

    InventoryTableModel inventorymodel;
    engine.rootContext()->setContextProperty("inventoryTable_model", &inventorymodel);

    ShippingTableModel shippingmodel;
    engine.rootContext()->setContextProperty("shippingTable_model", &shippingmodel);

    CustomUser customuser;
    engine.rootContext()->setContextProperty("custom_user", &customuser);

    engine.rootContext()->setContextProperty("$QmlEngine", &engine);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    pQmlRootObject = engine.rootObjects().at(0);

    InitializeForAndroidBattery();

    InitializeForAndroidInformation();

    return app.exec();
}
