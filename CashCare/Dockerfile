# Use an Ubuntu-based image
FROM ubuntu:22.04

# Set the working directory inside the container
WORKDIR /app

# Install dependencies and Qt6
RUN apt update && apt install -y \
    software-properties-common \
    wget \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-tools-dev \
    qt6-base-dev-tools \
    qml6-module-qtqml \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-layouts \
    qml6-module-qtquick-window \
    qml6-module-qt-labs-platform \
    libqt6quick6 \
    libpcap-dev \
    sudo \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxcb-xinerama0 \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Copy the application files into the container
COPY . /app

# Set up the Qt6 environment
ENV PATH=/usr/lib/qt6/bin:$PATH

# Make sure your .pro file includes the QML module
RUN echo "QT += quick" > CashCare.pro && \
    echo "SOURCES += main.cpp" >> CashCare.pro && \
    echo "RESOURCES += qml.qrc" >> CashCare.pro

# Build the Qt application
RUN qmake6 && make

# Give execution permissions to the compiled app
RUN chmod +x CashCare

# Run the application
CMD ["./CashCare"]
