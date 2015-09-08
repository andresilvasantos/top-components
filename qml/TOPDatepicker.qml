import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import "DateUtils.js" as DateUtils

Item {
    id: datepicker
    height: 20

    property date selectedDate : new Date()

    signal dateChanged (string date)

    function updateDate(date) {
        selectedDate = date;
        calendar.selectedDate = selectedDate;
        dateField.text = calendar.selectedDateText;
    }

    /*!
      \qmlmethod Datepicker::showModal()
      Toogle between show or hide the window with the calendar
    */
    function toggleModal() {
        if(modal.active)
            loseFocus();
        else
        {
            modal.show()
            modal.requestActivate()
        }
    }

    /*!
      \qmlmethod Datepicker::loseFocus( Date newDate )
      Sets the actual date, close the modal window.
    */
    function loseFocus(newDate) {
        if (newDate instanceof Date)
        {
            selectedDate = newDate;
            calendar.selectedDate = selectedDate;
            dateField.text = calendar.selectedDateText;
            dateChanged(calendar.selectedDate.getDate() + "/" + calendar.selectedDate.getMonth() + "/" + calendar.selectedDate.getFullYear());
        }
        else
            calendar.selectedDate.setDate(selectedDate.getDate());

        modal.close();
        //activeWindow.requestActivate();
    }

    Rectangle {
        id: dateFieldHolder
        color: "#cccccc"
        width: parent.width
        height: parent.height

        Text {
            id: dateField
            color: "#7e8387"
            anchors.centerIn: parent
        }

        MouseArea {
            hoverEnabled: true

            onEntered: {
                dateFieldHolder.color = "#b9e1fc"
            }

            onExited: {
                dateFieldHolder.color = "#cccccc"
            }

            anchors.fill: parent
            onClicked: toggleModal()
        }

    }

    Window {
        id: modal
        modality: Qt.ApplicationModal
        flags: Qt.SplashScreen
        minimumHeight: calendar.height; minimumWidth: calendar.width
        maximumHeight: calendar.height; maximumWidth: calendar.width

        Calendar {
            id: calendar
            selectedDateFormat: "dd MMMM yyyy"
            onDoubleClicked: loseFocus(calendar.selectedDate)
            onEscapePressed: loseFocus()
            onEnterPressed: loseFocus(calendar.selectedDate)
        }
    }
    Component.onCompleted: updateDate(calendar.selectedDate)
    //onDateChanged: console.debug("me quieren cambiar por", date) //calendar.selectedDate = selectedDate
}

