# Zastosowanie drzew decyzyjnych w analizie popytu na system rowerów miejskich

### Wstęp
Celem niniejszego projektu jest analiza czynników wpływających na liczbę wypożyczeń rowerów miejskich oraz budowa modelu predykcyjnego pozwalającego prognozować popyt.
Analizę oparto o dane historyczne obejmujące parametry pogodowe takie jak temperatura (temp), wilgotność (hum), prędkość wiatru (windspeed) oraz ogólna sytuacja pogodowa (weathersit) oraz parametry kalendarzowe: pora roku (season), dzień świąteczny (holiday) i dzień roboczy (workingday).
Badanie przeprowadzono budując dwa niezależne modele, model klasyfikacyjny przewiduje natężenie ruchu (duży/mały), natomiast model regresyjny przewiduje ile dokładnie rowerów zostanie wypożyczonych.

### Metodologia
Do analizy wykorzystano pakiet tree. W pierwszej kolejności dane surowe zostały przetworzone na wartości rzeczywiste.

## Zmienne Ilościowe
Oryginalne dane były znormalizowane (wartości 0-1). Aby wyniki były zrozumiałe, przeliczono je na jednostki fizyczne:
Temperatura (temp): Przeliczona na stopnie Celsjusza (zakres -8°C do 39°C).
Wilgotność (hum): Przeliczona na procenty (0-100%).
Prędkość wiatru (windspeed): Przeliczona na km/h.

## Zmienne Jakościowe
Zmienne kategorialne zostały przekonwertowane na faktory, aby algorytm nie traktował ich jak zwykłych liczb:
Pora roku (season): Podział na 4 okresy (1: Wiosna, 2: Lato, 3: Jesień, 4: Zima).
Sytuacja pogodowa (weathersit): Ogólna ocena (1: Słonecznie/Bezchmurnie, 2: Zachmurzenie/Mgła, 3: Lekki deszcz/Śnieg, 4: Ulewa/Burza).
Dzień świąteczny (holiday): Informacja, czy dany dzień jest świętem państwowym.
Dzień roboczy (workingday): Informacja, czy jest to dzień roboczy

## Zmienne Celu
Liczba wypożyczeń (cnt): Główna zmienna do modelu regresji (całkowita liczba rowerów).
Kategoria Ruchu (Ruch): Zmienna stworzona na potrzeby klasyfikacji. Dni podzielono na te o "Dużym" i "Małym" popycie, biorąc za punkt odcięcia średnią wartość z całego okresu.
Zbiór został podzielony losowo w proporcji 70:30. 70% danych posłużyło do treningu modelu, a 30% do testowania jego skuteczności.

# Teoria
Metoda drzew decyzyjnych polega na rekurencyjnym podziale zbioru danych na mniejsze podzbiory. W każdym kroku algorytm szuka reguły, która najlepiej rozdziela obserwacje na jednorodne grupy.

## Problem Przeuczenia
Algorytm ma tendencję do budowania zbyt skomplikowanych struktur. Drzewo pełne chce dopasować się do każdego pojedynczego przypadku w danych treningowych, co prowadzi do utraty zdolności generalizacji.

![Drzewo Klasyfikacyjne (pełne)](images/drzewo_klasyfikacyjne_pełne.png)
*Rys. 1. Drzewo decyzyjne przed optymalizacją. Duża ilość gałęzi wskazuje na zjawisko przeuczenia.*









