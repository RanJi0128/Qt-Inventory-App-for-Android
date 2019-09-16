#include "database.h"

DataBase::DataBase(QObject *parent) : QObject(parent)
{
    m_dbState="ok";
}
DataBase::~DataBase()
{
    closeDataBase();
}
void DataBase::connectToDataBase()
{
    QFile dfile("assets:/db/" DATABASE_NAME);

    if(!dfile.exists()){

        m_dbState = "No Database";

    } else {

//        if (QFile::exists("./" DATABASE_NAME))
//        {
//            QFile::remove("./" DATABASE_NAME);
//        }
        dfile.copy("./" DATABASE_NAME);
        QFile::setPermissions("./" DATABASE_NAME,QFile::WriteOwner | QFile::ReadOwner | QFile::ExeOwner);
        this->openDataBase();
    }

}
void DataBase::openDataBase()
{

    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName(DATABASE_HOSTNAME);
    db.setDatabaseName("./" DATABASE_NAME);

    if(db.open()){

        m_dbState = "ok";

    } else {

        m_dbState = "Open error Database";
    }
}
void DataBase::closeDataBase()
{
    db.close();
}

