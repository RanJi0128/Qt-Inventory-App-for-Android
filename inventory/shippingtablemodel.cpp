#include "shippingtablemodel.h"
#include <android/log.h>
#include "include.h"

ShippingTableModel::ShippingTableModel(QObject *parent) : QAbstractTableModel(parent)
{


}

int ShippingTableModel::rowCount(const QModelIndex &) const
{
    return table.size();//Number of rows
}

int ShippingTableModel::columnCount(const QModelIndex &) const
{
    if(rowCount() > 0)
      return table.at(0).size();//Columns
    else
      return 0;
}

QVariant ShippingTableModel::data(const QModelIndex &index, int role) const
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
QVariant ShippingTableModel::getData(int row, int columnId)
{

    if(rowCount() > 0)
     {

        return table.at(row).at(columnId);
     }

    return QVariant();
}
bool ShippingTableModel::insertData(QString oderStr, QString shipStr,int key)
{

       QSqlQuery query;
       query.prepare("SELECT order_val FROM shipping WHERE order_val = :order_val");
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
       query.prepare("INSERT INTO shipping (key, order_val, ship_val) VALUES (:key, :order_val, :ship_val)");
       query.bindValue(":key", key);
       query.bindValue(":order_val", oderStr);
       query.bindValue(":ship_val", shipStr);
       if(query.exec())
       {
           return true;
       }

       return false;
}
bool ShippingTableModel::updateData(QString oderStr, QString shipStr, int key, QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("UPDATE shipping SET key=:key, order_val=:order_val, ship_val=:ship_val WHERE pri_id=:pri_id");
        query.bindValue(":key", key);
        query.bindValue(":order_val", oderStr);
        query.bindValue(":ship_val", shipStr);
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
bool ShippingTableModel::deleteData(QString pri_id)
{
//      QByteArray ba = pri_id.toLocal8Bit();
//      const char *c_str2 = ba.data();
//    __android_log_write(ANDROID_LOG_INFO,"call-------------->",c_str2);
        QSqlQuery query;
        query.prepare("DELETE FROM shipping WHERE pri_id=:pri_id;");
        query.bindValue(":pri_id", pri_id.toInt());

        if(query.exec())
        {
           return true;
        }

        return false;
}
void ShippingTableModel::deleteAllData()
{
   table.clear();

   QSqlQuery query;
   query.prepare("DELETE FROM shipping");
   query.exec();


}
void ShippingTableModel::getReadAllData(int key_id)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM shipping;");
    query.exec();
    table.clear();
    while (query.next()) {

       int key = query.value(1).toInt();
       if(key == key_id)
       {
           QString pri_id = query.value(0).toString();
           QString join_id = query.value(1).toString();
           QString order = query.value(2).toString();
           QString ship_val = query.value(3).toString();
           table.append({pri_id,join_id,order,ship_val});
       }

    }

}
QString ShippingTableModel::getCSVData()
{
    QString data=" ";
    data="pri_id,key,order_val,ship_val\n";
    for(int i=0;i<rowCount();i++)
    {
        data = data + table.at(i).at(0)+","+table.at(i).at(1)+","+table.at(i).at(2)+","+table.at(i).at(3)+"\n";
    }
    return data;

}
QHash<int, QByteArray> ShippingTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Pri_id] = "Pri_id";
    roles[Key] = "Key";
    roles[Tags] = "Tags";
    roles[Order] = "OrderNumber";
    return roles;
}

