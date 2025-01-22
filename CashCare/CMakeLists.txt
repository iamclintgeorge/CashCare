cmake_minimum_required(VERSION 3.16)

project(CashCare VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appCashCare
    main.cpp
)

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
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCashCare PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCashCare
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCashCare
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appCashCare
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
