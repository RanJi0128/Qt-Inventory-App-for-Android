#include "logintablemodel.h"


LoginTableModel::LoginTableModel(QObject *parent) : QAbstractTableModel(parent)
{

     getData();

}

int LoginTableModel::rowCount(const QModelIndex &) const
{

    return table.size();//Number of rows
}

int LoginTableModel::columnCount(const QModelIndex &) const
{
    if(rowCount() > 0)
      return table.at(0).size();//Columns
    else {
        return 0;
    }
}

QVariant LoginTableModel::data(const QModelIndex &index, int role) const
{

    int columnId = role - Qt::UserRole - 1;

    if(rowCount() > 0)
      return table.at(index.row()).at(columnId);

    return QVariant();

}

QHash<int, QByteArray> LoginTableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "Key";
    roles[NameRole] = "Name";
    roles[PasswdRole] = "Passwd";
    roles[PermissionRole] = "Permission";
    return roles;
}
void LoginTableModel::getData()
{

    QSqlQuery query;
    query.prepare("SELECT * FROM login;");
    query.exec();

    while (query.next()) {

       QString key = query.value(0).toString();
       QString name = query.value(1).toString();
       QString passwd = query.value(2).toString();
       QString permission = query.value(3).toString();

       table.append({key,name,passwd,permission});

    }
}
QList<int> LoginTableModel::confirmUser(QString name, QString password, int key)
{
  QList<int> log_info;
  \
  if(rowCount() > 0)
  {
     QByteArray passwd;
     passwd.append(password);

   if(table.at(key).at(1) == name && table.at(key).at(2) == QString(QCryptographicHash::hash(passwd,QCryptographicHash::Md5).toHex()))
     {
          log_info.append(table.at(key).at(0).toInt());
          log_info.append(table.at(key).at(3).toInt());

     }
  }
   return log_info;
}
