cmake_minimum_required(VERSION 3.16)

project(CashCare VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt6 and required components
find_package(Qt6 REQUIRED COMPONENTS Quick Network)

# Npcap configuration for Windows
if (WIN32)
    set(NPCAP_INCLUDE_DIR "C:/Program Files/Npcap/Include")
    set(NPCAP_LIBRARY_DIR "C:/Program Files/Npcap/Lib/x64")
    set(PCAP_LIBRARY "${NPCAP_LIBRARY_DIR}/wpcap.lib")
else()
    include_directories("/usr/include/pcap")
    link_directories("/usr/lib/x86_64-linux-gnu/")
    set(PCAP_LIBRARY pcap)
endif()

# Include directories for header files
include_directories(${CMAKE_SOURCE_DIR}/include)

# Standard Qt project setup
qt_standard_project_setup(REQUIRES 6.5)

# Add the executable with refactored source files
qt_add_executable(appCashCare
    main.cpp
    networksniffer.cpp
    packetparser.cpp
    networkutils.cpp
)

# Add QML module
qt_add_qml_module(appCashCare
    URI CashCare
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        images/dashboard.png
        images/firewall.png
        images/network.png
        images/log.png
        images/settings.png
        images/notification.png
        images/profile.png
        images/search.png
        QML_FILES DashboardPage.qml
        QML_FILES Sidebar.qml
        QML_FILES
        QML_FILES
        QML_FILES
        QML_FILES Navbar.qml
        QML_FILES Statusbar.qml
        QML_FILES FirewallRulesetPage.qml
        QML_FILES NetworkSnifferPage.qml
        QML_FILES PacketDetailsWindow.qml
        QML_FILES
        QML_FILES LogPage.qml #NetworkSniffer.qml
)

# Set target properties
set_target_properties(appCashCare PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link necessary libraries
target_link_libraries(appCashCare
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Network
    PRIVATE ${PCAP_LIBRARY}
)

# Install targets
include(GNUInstallDirs)
install(TARGETS appCashCare
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Add a post-build step to copy Npcap DLL on Windows
if (WIN32)
    if (EXISTS "${NPCAP_LIBRARY_DIR}/wpcap.dll")
        add_custom_command(TARGET appCashCare POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${NPCAP_LIBRARY_DIR}/wpcap.dll"
                $<TARGET_FILE_DIR:appCashCare>
            COMMENT "Copying Npcap DLL to output directory"
        )
    else()
        message(WARNING "wpcap.dll not found at ${NPCAP_LIBRARY_DIR}/wpcap.dll. Please ensure Npcap is installed.")
    endif()
endif()
