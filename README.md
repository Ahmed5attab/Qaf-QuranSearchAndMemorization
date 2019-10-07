# Qaf-QuranSearchAndMemorization
iOS Islamic application for the holy Quran, helps the Muslims to have the Quran the hole time in there phons to read , memorize and to search for specified verses on it. 
Also to test them self by auto memorization and evaluation.

# How to run this Project

Just clone or download this project on your machine and open Quran.xcworkspace file and run it.

## This Project is built using:

XCode 9.2
Swift 4.0

# Application Scenes:

### SurasViewController:
The home Screen is a Table View contains two deferent custom cells.
The first one have all the 114 Suras, you can see each Sura’s Name, Chapter, and location (Mecca or Madina). You should select the Sura which you want to read and recite it’s specified verses. After clicking on it, a sub view will pop-up to choose verses range (for Ex: you want to recite “Al Fatihah” Sura only from verse 1 to verse 5). You will find 2 picker view which help you to do that.
The second cell triggered by the search bar above the table view showing all the verses that contains the search bar text and it's details. 

### QuranReadingViewController:
In this view you will find your chosen verses text to revise it before recitation. You will find also Sura’s Name and Chapter above the Verses. You can click Start Recitation Button after being ready.

### QuranResultsViewController: 
In this view you can recite the verses using Speech Recognition techniques by clicking on the green button. After finishing click on it again and the Verses text will appear with colors (Green for correct words which you say, and Red for wrong ones). You will get also a percentage of your Goodness in Memorizing this verses.
