#include "hostresolver.h"
#include <QHostInfo>
#include <QDebug>

HostResolver::HostResolver(QObject *parent)
    : QObject(parent), networkManager(new QNetworkAccessManager(this)) {
    connect(networkManager, &QNetworkAccessManager::finished, this, &HostResolver::onReplyFinished);
}

HostResolver::~HostResolver() {
    for (auto it = activeTimers.begin(); it != activeTimers.end(); ++it) {
        delete it.value();
    }
}

void HostResolver::startResolving(const QString &hostname, int intervalMs) {
    if (activeTimers.contains(hostname)) {
        qDebug() << "Resolving already started for" << hostname;
        return;
    }

    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, [this, hostname]() {
        resolveHost(hostname);
    });

    activeTimers[hostname] = timer;
    timer->start(intervalMs);

    qDebug() << "Started resolving for" << hostname;
}

void HostResolver::stopResolving(const QString &hostname) {
    if (activeTimers.contains(hostname)) {
        QTimer *timer = activeTimers[hostname];
        timer->stop();
        delete timer;
        activeTimers.remove(hostname);
        qDebug() << "Stopped resolving for" << hostname;
    } else {
        qDebug() << "No active resolving for" << hostname;
    }
}

void HostResolver::resolveHost(const QString &hostname) {
    QHostInfo::lookupHost(hostname, this, [this, hostname](const QHostInfo &info) {
        if (info.error() == QHostInfo::NoError && !info.addresses().isEmpty()) {
            QString ip = info.addresses().first().toString();
            emit hostResolved(QVariant::fromValue(hostname), QVariant::fromValue(ip));
            stopResolving(hostname);
            qDebug() << "Resolved hostname:" << hostname << "to IP:" << ip;
        } else {
            qDebug() << "Failed to resolve hostname:" << hostname << "Error:" << info.errorString();
        }
    });
}

void HostResolver::onReplyFinished(QNetworkReply *reply) {
    reply->deleteLater();
    qDebug() << "HTTP request finished for" << reply->url().host();
}