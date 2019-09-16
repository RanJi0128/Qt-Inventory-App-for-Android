#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QFile>
#include <QDate>
#include <QDebug>

#define DATABASE_HOSTNAME   "localhost"
#define DATABASE_NAME       "inventory.db"

class DataBase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString dbState READ dbState)
public:
    explicit DataBase(QObject *parent = nullptr);
    ~DataBase();
    void connectToDataBase();


    QString m_dbState;

    QString dbState() const {

           return m_dbState;
       }

public:
    QSqlDatabase db;

private:
    void openDataBase();
    void closeDataBase();     

signals:

public slots:
};

#endif // DATABASE_H
