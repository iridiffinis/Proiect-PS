/*1*/
DATA produse;
length Denumire_produs $20;
length Categorie $20;
	infile '/home/u63361589/produse.txt' dsd;
	input Cod_produs $ Denumire_produs $ Categorie $ Cantitate Pret_fara_TVA TVA Pret_cu_TVA Suma_fara_TVA Suma_TVA Suma_totala;
RUN;
DATA vanzari;
length Client $20;
length Denumire_produs $20;
	infile '/home/u63361589/vanzari.txt' dsd;
	input Cod_client $ Client $ Cod_produs $ Denumire_produs $ Cantitate_comandata UM $ Pret_unitar_vanzare Valoare Cod_furnizor $ Furnizor $;
RUN;

/* 2 */
proc sort data=vanzari;
	by Cod_furnizor;
run;
data vanzari_furnizori;
	total_vanzari = 0;
	do until (last.Cod_furnizor);
		set vanzari;
		by Cod_furnizor;
		total_vanzari + Valoare;
	end;
	output;
	drop Cod_client Client Cod_produs Denumire_produs Cantitate_comandata UM Pret_unitar_vanzare Valoare Furnizor;
run;
proc print data=vanzari_furnizori;
run;

/* 3 */
proc sort data=vanzari;
	by Cod_produs;
run;
proc format;
	value categorie_format
		low-49999 = 'vanzare redusa'
		50000 - 99999='vanzare medie'
		100000 - high = 'vanzare ridicata';
run;
data valori_produse;
	set vanzari;
	by Cod_produs;
	array valori[15] valoare_1 - valoare_15;
	if first.Cod_produs then do;
		do i = 1 to 15;
			valori[i] = 0;
		end;
	end;
	do i = 1 to 12;
		valori[i] + Valoare;
	end;
	if LAST.Cod_produs then do;
		Valoare_totala = sum(of valori[*]);
        Categorie_vanzare = put(sum(of valori[*]), categorie_format.);
        output;
    end;

    drop i valoare_1 - valoare_15;
run;
proc print data=valori_produse;
	var Cod_produs Denumire_produs Valoare_totala Categorie_vanzare;
run;

/* 4 */
proc means data=produse sum;
	var Cantitate;
	class Categorie;
	output out=cantitate_totala
			sum=Cantitate_totala;
run;
proc gchart data=cantitate_totala;
	vbar Categorie / sumvar=Cantitate_totala;
run;










