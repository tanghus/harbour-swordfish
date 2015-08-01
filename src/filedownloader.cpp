/*
Copyright (C) 2015 Thomas Tanghus <thomas@tanghus.net>
All rights reserved.

You may use this file under the terms of BSD license as follows:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "filedownloader.h"

FileDownloader::FileDownloader(QObject *parent) :
 QObject(parent) {
    filePath = getFileName();
}

FileDownloader::~FileDownloader() { }

QString FileDownloader::getFileName() {
    QString cacheDirPath = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
    QDir cacheDir(cacheDirPath);

    if(!cacheDir.exists()) {
        cacheDir.mkpath(cacheDirPath);
    }

    return cacheDirPath + QString("/audio.mp3");
}

void FileDownloader::download(const QString &uri) {
    QUrl url(uri);

    connect(&m_WebCtrl, SIGNAL (finished(QNetworkReply*)),
            this, SLOT (fileDownloaded(QNetworkReply*))
    );

    QNetworkRequest request(url);
    m_WebCtrl.get(request);
}

void FileDownloader::fileDownloaded(QNetworkReply* pReply) {
    m_DownloadedData = pReply->readAll();

    QFile file(filePath);
    file.open(QIODevice::WriteOnly | QIODevice::Truncate);
    file.write(m_DownloadedData);
    file.close();

    //emit a signal
    pReply->deleteLater();
    emit downloaded(filePath);
}

QByteArray FileDownloader::downloadedData() const {
    return m_DownloadedData;
}
