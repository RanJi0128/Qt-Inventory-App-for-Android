#include "inventorytablemodel.h"
#include <android/log.h>
#include "include.h"

InventoryTableModel::InventoryTableModel(QObject *parent) : QSqlQueryModel(parent)
{


}

int InventoryTableModel::rowCount(const QModelIndex &) const
{
    return table.size();//Number of rows
}

int InventoryTableModel::columnCount(const QModelIndex &) const
{
    if(rowCount() > 0)
      return table.at(0).size();//Columns
    else
      return 0;
}

QVariant InventoryTableModel::data(const QModelIndex &index, int role) const
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
QVariant InventoryTableModel::getData(int row, int columnId)
{

    if(rowCount() > 0)
      return table.at(row).at(columnId);

    return QVariant();
}
bool InventoryTableModel::insertData(QString phyStr, QString lctStr,QString sublctStr,int key)
{

       QSqlQuery query;
       query.prepare("SELECT physical FROM inventory WHERE physical = :physical");
       query.bindValue(":physical", phyStr);
       if(query.exec())
       {
           if(query.first())
           {
             ConfirmMessageDlg("Input Error","Physical count exists already !");
             return false;
           }

       }
       else {
         return false;
       }
       query.prepare("INSERT INTO inventory (key, physical, location,sub_location) VALUES (:key, :physical, :location, :sub_location)");
       query.bindValue(":key", key);
       query.bindValue(":physical", phyStr);
       query.bindValue(":location", lctStr);
       query.bindValue(":sub_location", sublctStr);
       if(query.exec())
       {
           return true;
       }


       return false;
}
bool InventoryTableModel::updateData(QString phyStr, QString lctStr,QString sublctStr,int key, QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("UPDATE inventory SET key=:key, physical=:physical, location=:location, sub_location=:sub_location WHERE pri_id=:pri_id");
        query.bindValue(":key", key);
        query.bindValue(":physical", phyStr);
        query.bindValue(":location", lctStr);
        query.bindValue(":sub_location", sublctStr);
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
bool InventoryTableModel::deleteData(QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("DELETE FROM inventory WHERE pri_id=:pri_id;");
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
void InventoryTableModel::deleteAllData()
{
   table.clear();

   QSqlQuery query;
   query.prepare("DELETE FROM inventory");
   query.exec();


}
void InventoryTableModel::getReadAllData(int key_id)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM inventory;");
    query.exec();
    table.clear();
    while (query.next()) {

       int key = query.value(1).toInt();
       if(key == key_id)
       {
           QString pri_id = query.value(0).toString();
           QString join_id = query.value(1).toString();
           QString physical = query.value(2).toString();
           QString location = query.value(3).toString();
           QString sub_location = query.value(4).toString();

           table.append({pri_id,join_id,physical,location,sub_location});
       }

    }

}
QString InventoryTableModel::getCSVData()
{
    QString data=" ";
    data="pri_id,key,physical,location,sub_location\n";
    for(int i=0;i<rowCount();i++)
    {
        data = data + table.at(i).at(0)+","+table.at(i).at(1)+","+table.at(i).at(2)+","+table.at(i).at(3)+table.at(i).at(4)+"\n";
    }
    return data;

}
QHash<int, QByteArray> InventoryTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Pri_id] = "Pri_id";
    roles[Key] = "Key";
    roles[Tags] = "Tags";
    roles[Physical] = "PhysicalCount";
    return roles;
}
