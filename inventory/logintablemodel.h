#ifndef LOGINTABLEMODEL_H
#define LOGINTABLEMODEL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QSqlQuery>
#include <QCryptographicHash>


class LoginTableModel : public QAbstractTableModel
{

public:

    Q_OBJECT
    Q_PROPERTY(QStringList nameModel READ getNameModel)

    enum TableRoles{
        IdRole = Qt::UserRole + 1,
        NameRole,
        PasswdRole,
        PermissionRole
    };
public:
    explicit LoginTableModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & = QModelIndex()) const override;
    int columnCount(const QModelIndex & = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void getData();

    QStringList getNameModel() const{

        QStringList nameList;

        for (int i=0;i<rowCount();i++) {

            nameList.append(table.at(i).at(1));
        }

        return nameList;
    }

    Q_INVOKABLE QList<int> confirmUser(QString name,QString password,int key);


signals:

public slots:

private:

    QVector<QVector<QString>> table;


};

#endif  // LOGINTABLEMODEL_H
