#include "tablemodel.h"
#include "include.h"
#include <android/log.h>

TableModel::TableModel(QObject *parent) : QAbstractTableModel(parent)
{


}

int TableModel::rowCount(const QModelIndex &) const
{
    return table.size();//Number of rows
}

int TableModel::columnCount(const QModelIndex &) const
{
    if(rowCount() > 0)
      return table.at(0).size();//Columns
    else
      return 0;

}

QVariant TableModel::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    if(rowCount() > 0)
    {
      switch(role)
      {
        case Tags:
          return index.row()+1;
        default:
          return table.at(index.row()).at(columnId);

      }
    }

    return QVariant();
}
QVariant TableModel::getData(int row, int columnId)
{

    if(rowCount() > 0)
      return table.at(row).at(columnId);

    return QVariant();
}

QHash<int, QByteArray> TableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Pri_id] = "Pri_id";
    roles[Key] = "Key";
    roles[Tags] = "Tags";
    roles[Order] = "WorkOrder";
    return roles;
}
bool TableModel::insertData(QString oderStr, QString lctStr,int key)
{

       QSqlQuery query;
       query.prepare("SELECT order_val FROM consump WHERE order_val = :order_val");
       query.bindValue(":order_val", oderStr);
       if(query.exec())
       {
           if(query.first())
           {
             ConfirmMessageDlg("Input Error","Order number exists already !");
             return false;
           }

       }
       else {
         return false;
       }
       query.prepare("INSERT INTO consump (key, order_val, location) VALUES (:key, :order_val, :location)");
       query.bindValue(":key", key);
       query.bindValue(":order_val", oderStr);
       query.bindValue(":location", lctStr);
       if(query.exec())
       {
           return true;
       }
       
       return false;
}
bool TableModel::updateData(QString oderStr, QString lctStr, int key, QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("UPDATE consump SET key=:key, order_val=:order_val, location=:location WHERE pri_id=:pri_id");
        query.bindValue(":key", key);
        query.bindValue(":order_val", oderStr);
        query.bindValue(":location", lctStr);
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
bool TableModel::deleteData(QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("DELETE FROM consump WHERE pri_id=:pri_id;");
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
void TableModel::deleteAllData()
{
   table.clear();

   QSqlQuery query;
   query.prepare("DELETE FROM consump");
   query.exec();


}
void TableModel::getReadAllData(int key_id)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM consump;");
    query.exec();
    table.clear();
    while (query.next()) {

       int key = query.value(1).toInt();
       if(key == key_id)
       {
           QString pri_id = query.value(0).toString();
           QString join_id = query.value(1).toString();
           QString order = query.value(2).toString();
           QString location = query.value(3).toString();
           
           table.append({pri_id,join_id,order,location});
       }
    
    }
 
}
QString TableModel::getCSVData()
{
    QString data=" ";
    data="pri_id,key,order_val,location\n";
    for(int i=0;i<rowCount();i++)
    {
        data = data + table.at(i).at(0)+","+table.at(i).at(1)+","+table.at(i).at(2)+","+table.at(i).at(3)+"\n";
    }
    return data;

}
