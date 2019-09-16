#ifndef TABLEMODEL_H
#define TABLEMODEL_H

#include <QObject>
#include <QSqlQuery>
#include <QAbstractTableModel>

class TableModel : public QAbstractTableModel
{
    Q_OBJECT
    enum TableRoles{
        Pri_id = Qt::UserRole + 1,
        Key,
        Order,
        Tags

    };
public:
    explicit TableModel(QObject *parent = nullptr);
    
    int rowCount(const QModelIndex & = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    
    Q_INVOKABLE void getReadAllData(int key);
    Q_INVOKABLE bool insertData(QString oderStr, QString lctStr,int key);
    Q_INVOKABLE bool updateData(QString oderStr, QString lctStr,int key, QString pri_id);
    Q_INVOKABLE QVariant getData(int row,int columnId);
    Q_INVOKABLE bool deleteData(QString pri_id);
    Q_INVOKABLE void deleteAllData();
    Q_INVOKABLE QString getCSVData();

signals:

public slots:

private:

    QVector<QVector<QString>> table;
};

#endif // TABLEMODEL_H
