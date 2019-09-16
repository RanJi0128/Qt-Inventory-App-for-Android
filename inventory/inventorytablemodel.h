#ifndef INVENTORYTABLEMODEL_H
#define INVENTORYTABLEMODEL_H

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlQuery>

class InventoryTableModel : public QSqlQueryModel
{

public:
    Q_OBJECT
    enum TableRoles{
        Pri_id = Qt::UserRole + 1,
        Key,
        Physical,
        Tags

    };
public:
    explicit InventoryTableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void getReadAllData(int key);
    Q_INVOKABLE bool insertData(QString phyStr, QString lctStr,QString sublctStr,int key);
    Q_INVOKABLE bool updateData(QString phyStr, QString lctStr,QString sublctStr,int key, QString pri_id);
    Q_INVOKABLE QVariant getData(int row,int columnId);
    Q_INVOKABLE bool deleteData(QString pri_id);
    Q_INVOKABLE void deleteAllData();
    Q_INVOKABLE QString getCSVData();

signals:

public slots:

private:


    QVector<QVector<QString>> table;
};

#endif // INVENTORYTABLEMODEL_H
