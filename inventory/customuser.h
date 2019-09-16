#ifndef CUSTOMUSER_H
#define CUSTOMUSER_H

#include <QObject>
#include <QtAndroidExtras>

#include <android/log.h>
class CustomUser : public QObject
{

public:

    Q_OBJECT
    Q_PROPERTY(QString serverAddress READ getServerAddress)
    Q_PROPERTY(QString serverUserName READ getServerUserName)
    Q_PROPERTY(QString sharedFolderName READ getSharedFolderName)
    Q_PROPERTY(QString serverPassword READ getSeverPassword)
    Q_PROPERTY(int logoffTime READ getLogoffTime)

public:
    explicit CustomUser(QObject *parent = nullptr);
    Q_INVOKABLE bool downloadFile(QString usrname,QString pass,QString ip_address,QString filePath,QString outStream);
    Q_INVOKABLE void sysLogoffTime(int logTime);
    Q_INVOKABLE void serverInfoFileSave(QString filename,QString out_1,QString out_2);
    Q_INVOKABLE void logoffTimeInfoFileSave(QString filename,int out);
    Q_INVOKABLE void getServerModel();
    Q_INVOKABLE void openNetworkSetting();

    QStringList serverInfo;

    int getLogoffTime() const{

        int logtime= 5;

        QFile file("./time.txt");
        if (file.exists())
        {
            if (file.open(QIODevice::ReadOnly))
            {
               QTextStream in(&file);
               while (!in.atEnd())
               {
                  logtime = in.readLine().toInt();
               }
               file.close();
            }
        }

        return logtime;
    }

    QString getServerAddress() const{

        QString ip_address="";

        if(serverInfo.length() > 0)
        {
            QStringList list = serverInfo.at(0).split('/');
            ip_address= list.at(0);
        }

        return ip_address;
    }
    QString getServerUserName() const{

        QString serverUserName="";

        if(serverInfo.length() > 0)
        {
            QStringList list = serverInfo.at(0).split('/');
            serverUserName = list.at(1);

        }

        return serverUserName;
    }
    QString getSharedFolderName() const{

        QString sharedFolderName="";

        if(serverInfo.length() > 0)
        {
            QStringList list = serverInfo.at(0).split('/');
            for(int i =2;i< list.length();i++)
              sharedFolderName += list.at(i);
        }

        return sharedFolderName;
    }
    QString getSeverPassword() const{

        QString serverPassword="";

        if(serverInfo.length() > 0)
        {
            serverPassword = serverInfo.at(1);
        }

        return serverPassword;
    }
    Q_INVOKABLE void listenTo(QObject *object)
    {
        if (!object)
            return;

        object->installEventFilter(this);
    }
    bool eventFilter(QObject *obj, QEvent *event)
    {
//        QByteArray ba = QString::number(event->type()).toLocal8Bit();
//        const char *c_str2 = ba.data();
//      __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);

      //  if(event->type() != QEvent::Timer)
        {
            // filter out RequestSoftwareInputPanel event
            emit inputFocus();
            //return true;
        }
       // else
        {
           // standard event processing
            return QObject::eventFilter(obj, event);
        }
    }

signals:
     void inputFocus();
public slots:
};

#endif // CUSTOMUSER_H
