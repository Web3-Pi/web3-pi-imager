#ifndef HOSTRESOLVER_H
#define HOSTRESOLVER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTimer>
#include <QMap>
#include <QVariant>

class HostResolver : public QObject {
    Q_OBJECT
public:
    explicit HostResolver(QObject *parent = nullptr);
    ~HostResolver();

    Q_INVOKABLE void startResolving(const QString &hostname, int intervalMs = 4000);
    Q_INVOKABLE void stopResolving(const QString &hostname);

    signals:
        void hostResolved(const QVariant &hostname, const QVariant &ip);

    private slots:
        void resolveHost(const QString &hostname);
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *networkManager;
    QMap<QString, QTimer *> activeTimers;
    QMap<QNetworkReply *, QString> activeRequests;
};

#endif