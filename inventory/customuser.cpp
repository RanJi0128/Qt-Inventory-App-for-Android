#include "customuser.h"


CustomUser::CustomUser(QObject *parent) : QObject(parent)
{

}
bool CustomUser::downloadFile(QString usrname,QString pass,QString ip_address,QString filePath,QString outStream)
{

    jboolean statue = false;

    statue = QAndroidJniObject::callStaticMethod<jboolean>("com/jni/systeminfo/NetworkManager", "downloadFile","(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z",
                                              QAndroidJniObject::fromString(usrname).object<jstring>(),
                                              QAndroidJniObject::fromString(pass).object<jstring>(),
                                              QAndroidJniObject::fromString(ip_address).object<jstring>(),
                                              QAndroidJniObject::fromString(filePath).object<jstring>(),
                                              QAndroidJniObject::fromString(outStream).object<jstring>());
    return statue;
}
void CustomUser::sysLogoffTime(int logTime)
{
    QAndroidJniObject::callStaticMethod<void>("com/jni/systeminfo/AppActivity", "sysLogoffTime","(I)V",logTime);
}
void CustomUser::serverInfoFileSave(QString filename,QString out_1,QString out_2)
{
    QFile file("./"+filename);
//    if (file.exists())
//    {
//        file.remove();
//    }
    QString out = out_1 + "\n" + out_2;
    if (file.open(QIODevice::ReadWrite) )
    {
        QTextStream stream(&file);
        stream << out << endl;

    }
}
void CustomUser::logoffTimeInfoFileSave(QString filename,int out)
{
    QFile file("./"+filename);
//    if (file.exists())
//    {
//        file.remove();
//    }
    if (file.open(QIODevice::ReadWrite) )
    {
        QTextStream stream(&file);
        stream << QString::number(out) << endl;
    }
}

void CustomUser::getServerModel()
{
    serverInfo.clear();

    QFile file("./server.txt");
    if (file.exists())
    {
        if (file.open(QIODevice::ReadOnly))
        {
           QTextStream in(&file);
           while (!in.atEnd())
           {
              QString line = in.readLine();
              serverInfo.append(line);
           }
           file.close();
        }
    }




}
void CustomUser::openNetworkSetting()
{
    QAndroidJniObject::callStaticMethod<void>("com/jni/systeminfo/OpenOtherApp", "openApp","(Landroid/content/Context;)V",
                                              QtAndroid::androidContext().object<jobject>());
}
