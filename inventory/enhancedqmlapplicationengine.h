#ifndef ENHANCEDQMLAPPLICATIONENGINE_H
#define ENHANCEDQMLAPPLICATIONENGINE_H

#include <QObject>
#include <QQmlApplicationEngine>

class EnhancedQmlApplicationEngine : public QQmlApplicationEngine
{
    Q_OBJECT
public:
    explicit EnhancedQmlApplicationEngine(QObject *parent = nullptr);

    Q_INVOKABLE void clearCache();
};

#endif // ENHANCEDQMLAPPLICATIONENGINE_H
