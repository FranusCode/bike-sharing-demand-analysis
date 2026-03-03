# ==============================================================================
# 1. PRZYGOTOWANIE DANYCH
# ==============================================================================

library(tree)

# Pobieranie danych
temp_file <- tempfile()
download.file("https://archive.ics.uci.edu/static/public/275/bike+sharing+dataset.zip", temp_file)
rowery <- read.csv(unz(temp_file, "day.csv"))
unlink(temp_file) 

# Wybór kolumn
dane = rowery[, c("season", "holiday", "workingday", "weathersit", "temp", "hum", "windspeed", "cnt")]

# Przeliczanie jednostek
dane$temp = (dane$temp * (39-(-8))) - 8      
dane$hum = dane$hum * 100                    
dane$windspeed = dane$windspeed * 67         

# Zmienna do klasyfikacji -> Ruch: Duży/Mały
srednia = mean(dane$cnt)
dane$Ruch = ifelse(dane$cnt > srednia, "Duzy", "Maly")
dane$Ruch = as.factor(dane$Ruch)

# Faktory
dane$season = as.factor(dane$season)       
dane$weathersit = as.factor(dane$weathersit)

# Podział zbioru
set.seed(123)
indeksy = sample(1:nrow(dane), size = 0.7 * nrow(dane))
train = dane[indeksy, ]
test = dane[-indeksy, ]

# ==============================================================================
# 2. DRZEWO KLASYFIKACYJNE 
# ==============================================================================

drzewo.class = tree(Ruch ~ . -cnt, data=train)

# Rys 1 i 2
plot(drzewo.class); text(drzewo.class, pretty=0); title("Drzewo klasyfikacyjne (pełne)")
drzewo.class_pruned = prune.tree(drzewo.class, best=5)
plot(drzewo.class_pruned); text(drzewo.class_pruned, pretty=0); title("Drzewo klasyfikacyjne (przycięte)")

# Rys 3: Mapa klasyfikacji
drzewo.wiz = tree(Ruch ~ temp + hum, data=train)
plot(train$temp, train$hum, type="n", xlab="Temperatura (°C)", ylab="Wilgotność (%)")
points(train$temp, train$hum, pch=19, col="gray")
text(train$temp, train$hum, c("D","M")[train$Ruch], col=c("green","red")[train$Ruch])
partition.tree(drzewo.wiz, add=TRUE, col="blue", lwd=2)
title("Obszary popytu (Klasyfikacja)")

# Skuteczność
prognoza = predict(drzewo.class_pruned, test, type="class")
print("Skuteczność klasyfikacji:"); print(table(test$Ruch, prognoza))

# ==============================================================================
# 3. DRZEWO REGRESYJNE 
# ==============================================================================

drzewo.reg = tree(cnt ~ . -Ruch, data=train)

plot(drzewo.reg); text(drzewo.reg); title("Drzewo regresyjne (pełne)")
drzewo.reg_pruned = prune.tree(drzewo.reg, best=5)
plot(drzewo.reg_pruned); text(drzewo.reg_pruned); title("Drzewo regresyjne (przycięte)")

# wizualizacja temperatura vs wiatr
plot(train$temp, train$windspeed, pch=19, col="gray",
     xlab="Temperatura (°C)", ylab="Prędkość wiatru (km/h)",
     main="Obszary popytu (regresja)")
drzewo.wiz_reg = tree(cnt ~ temp + windspeed, data=train, 
                      control = tree.control(nobs=nrow(train), mindev=0.005))
partition.tree(drzewo.wiz_reg, add=TRUE, col="red", lwd=3)
text(drzewo.wiz_reg, pretty=0, col="red", cex=1.5, font=2)

# błąd prognozy (RMSE)
pred = predict(drzewo.reg_pruned, test)
rmse = sqrt(mean((test$cnt - pred)^2))
print(paste("RMSE:", round(rmse, 0), "rowerów"))

# przykładowa predykcja
# Lato (2), 25 stopni, Słonecznie (1), Wiatr 15 km/h
nowy = train[1, ]
nowy$season = as.factor(2); nowy$temp = 25; nowy$weathersit = as.factor(1)
nowy$hum = 50; nowy$windspeed = 15
wynik = predict(drzewo.reg_pruned, nowy)
print(paste("Prognoza dla 25 stopni w lato:", round(wynik, 0), "rowerów"))