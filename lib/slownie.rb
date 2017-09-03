# ----------------------------------------
#         Napisz słownie liczbę
#         Wersja 1, 21/03/2006
#
#         Autor: Rafał Komorowski
#         Licencja: public domain
# ----------------------------------------
#
# ENGLISH DESCRIPTION:
# This class expands a number (Fixnum or Bignum) into a string with a textual representation of that number in Polish language.
# Example: 456 -> "four hundred fifty six" (but in Polish)
# Current limitations: no Floats allowed.
# Configuration possibilities: extend currencies list (Waluta hash).
# To do: Floats (cents, eurocents, etc., or just a fraction). Named attributes (as seen in Rails and such).
#
# POLSKI OPIS:
# Ta klasa zamienia liczbę (Fixnum lub Bignum) na string z tekstową reprezentacją tej liczby w języku polskim.
# Przykład: 456 -> "czterysta pięćdziesiąt sześć"
# Aktualne ograniczenia: nie przyjmuje Floatów.
# Możliwości konfigurowania: można dodać nowe waluty (hash Waluta).
#


class Slownie

  # Liczba - hash przechowujący słowny zapis liczb z uwzględnieniem przypadków, gdzie potrzeba (tysiące, miliony, ...)
  Liczba = {
    0     => '',
    1     => 'jeden',
    2     => 'dwa',
    3     => 'trzy',
    4     => 'cztery',
    5     => 'pięć',
    6     => 'sześć',
    7     => 'siedem',
    8     => 'osiem',
    9     => 'dziewięć',
    10    => 'dziesięć',
    11    => 'jedenaście',
    12    => 'dwanaście',
    13    => 'trzynaście',
    14    => 'czternaście',
    15    => 'piętnaście',
    16    => 'szesnaście',
    17    => 'siedemnaście',
    18    => 'osiemnaście',
    19    => 'dziewiętnaście',
    20    => 'dwadzieścia',
    30    => 'trzydzieści',
    40    => 'czterdzieści',
    50    => 'pięćdziesiąt',
    60    => 'sześćdziesiąt',
    70    => 'siedemdziesiąt',
    80    => 'osiemdziesiąt',
    90    => 'dziewięćdziesiąt',
    100   => 'sto',
    200   => 'dwieście',
    300   => 'trzysta',
    400   => 'czterysta',
    500   => 'pięćset',
    600   => 'sześćset',
    700   => 'siedemset',
    800   => 'osiemset',
    900   => 'dziewięćset',
    # tu lecą jednostki odmieniane przez przypadki
    1000  => { 1 => 'tysiąc', 2 => 'tysiące', 5 => 'tysięcy' },
    1000000 => { 1 => 'milion', 2 => 'miliony', 5 => 'milionów' },
    1000000000 => { 1 => 'miliard', 2 => 'miliardy', 5 => 'miliardów' }.freeze
  }

  # Waluta - hash przechowujący waluty - ich odmianę przez przypadki
  Waluta = {
    'PLN' => { 1 => 'złoty', 2 => 'złote', 5 => 'złotych' },
    'USD' => { 1 => 'dolar', 2 => 'dolary', 5 => 'dolarów' },
    'EUR' => { 1 => 'euro', 2 => 'euro', 5 => 'euro' }
  }

  # Główna metoda - ją wywołujemy, jako class-method
  def Slownie.slownie(liczba, separator =' ', waluta = 'PLN')
    raise "SLOWNIE: Nie obsługujemy jeszcze Floatów, niestety!" if liczba.class == Float
    return ('zero ' + Slownie.przypadek(0, Liczba[waluta])) if liczba == 0
    @sep = separator
    res = ''
    if liczba > 999999999   # miliardy
      mlds = liczba / 1000000000 % 1000
      res << Slownie.set(mlds) + Slownie.dziesiat(mlds) + Slownie.przypadek(mlds, Liczba[1000000000]) + @sep
    end
    if liczba > 999999   # miliony
      mlns = liczba / 1000000 % 1000
      if mlns != 0
        res << Slownie.set(mlns) + Slownie.dziesiat(mlns % 100) + Slownie.przypadek(mlns, Liczba[1000000]) + @sep
      end
    end
    if liczba > 999   # tysiące
      tys = liczba / 1000 % 1000
      if tys != 0
        res << Slownie.set(tys) + Slownie.dziesiat(tys % 100) + Slownie.przypadek(tys, Liczba[1000]) + @sep
      end
    end
    jedn = liczba % 1000
    res << Slownie.set(jedn % 1000) + Slownie.dziesiat(jedn % 100)
    if waluta != ''
      res << Slownie.przypadek(liczba, Waluta[waluta]) + @sep
    end
    res.chomp!(@sep)
    return res
  end

  protected
  def Slownie.set(liczba)
    if liczba > 99
      return Liczba[liczba - (liczba % 100)] + @sep
    else
      return ''
    end
  end

  def Slownie.dziesiat(liczba)
    liczba = liczba % 100
    if liczba == 0
      return ''
    elsif liczba < 20
      return Liczba[liczba] + @sep
    elsif (liczba % 10) != 0
      return Liczba[liczba - liczba % 10] + @sep + Liczba[liczba % 10] + @sep
    else
      return Liczba[liczba - liczba % 10] + @sep
    end
  end

  def Slownie.przypadek(liczba, czego)
    liczba = liczba % 100
    flag21 = false
    if (liczba % 100) > 21
      liczba = (liczba % 10)
      flag21 = true
    end
    if liczba == 0 then czego[5]
      elsif liczba == 1 then flag21 ? czego[5] : czego[1]
      elsif (liczba >= 2 and liczba <= 4) then czego[2]
      elsif liczba >= 5 then czego[5]
    end
  end
end
