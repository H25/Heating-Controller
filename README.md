# Heating Controller

## Description
The app was developed with the Framework Flutter as a result of project at our university.</br>
The aim of this app is to visualize different values of a heating system. Additionaly, the furnace's hatch can be opened.

## Pages
The following images were taken in German, but the app is also translated to English.
### Home
Displays the current values. If the hatch is closed it is possible to open it. Making a pull to refresh gesture will force an immediate update of the database. 
</br></br>
<img src="doc/images/home_with_drawer_open.png" alt="Home with Drawer open" width="200"/>
<img src="doc/images/home.png" alt="Home" width="200"/>

### History
The history page shows the measurements in a specified time intervall. The different chart entries can be hidden by clicking on the corresponding legend entry.
</br></br>
<img src="doc/images/history.png" alt="History" width="200"/>
</br></br>
<img src="doc/images/history_landscape_some_deselected.png" alt="History Landscape" width="500"/>

### Settings
Here you can switch between Demo and Prod Mode. In Demo Mode, the values are created randomly and there is no connection to any webserver. In Prod Mode, you can also select which connection the app should use - IP or VPN address.
</br></br>
<img src="doc/images/settings.png" alt="Settings" width="200"/>
