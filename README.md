# Reservoir-Computing-on-the-Hypersphere
Questo progetto prevede attività di peer-review dell'articolo [Reservoir Computing on the Hypersphere](https://github.com/Simone-Scalella/Reservoir-Computing-on-the-Hypersphere/blob/main/Reservoir%20Computing%20on%20the%20Hypersphere.pdf).
In questo progetto si è proceduto a replicare i risultati ottenuti dagli autori del paper e si è realizzata una nuova implementazione in matlab, che svolge lo stesso lavoro, su cui sono state fatte delle prove.
Per maggiori approfondimenti si invita a leggere la [relazione](https://github.com/Simone-Scalella/Reservoir-Computing-on-the-Hypersphere/blob/main/Relazione_finale.pdf) di questo progetto.
Riportiamo l'abstract e le conclusioni dell'articolo, per poter trasmettere sufficienti informazioni su di esso e sul lavoro svolto.

## Astrazione
Reservoir Computing si riferisce a un framework di reti neurali ricorrenti (RNN), spesso utilizzati per l’apprendimento sequenziale e la previsione. Questo sistema e’ costituito da un RNN a peso fisso casuale e un classificatore. Noi ci concentriamo sul problema della sequenza di apprendimento, ed esploriamo un approccio diverso al RC. Più precisamente noi rimuoviamo le funzioni di attivazione neurale non lineare, e consideriamo un reservoir agendo sullo stato di normalizzazione della sfera unitaria. I risultati mostrano che la capacità di memoria del sistema supera la dimensione del reservoir, che è il limite superiore per il tipico approccio RC basato su ECHO STATE NETWORKS. Adesso mostriamo come il sistema proposto può essere applicato a problemi di crittografia simmetrica.

## Conclusioni
In questo articolo è stato presentato un nuovo modello RC con le dinamiche vincolate all’ipersfera unitaria.Il modello rimuove la funzione di attivazione neurale non lineare e utilizza matrici di reservoir ortogonali. I nostri risultati numerici hanno mostrato che la capacità di memoria del sistema è maggiore della dimensionalità del reservoir, che è il limite superiore per il tipico approccio RC basato su ESN. Abbiamo anche discusso l’applicazione del sistema alla crittografia simmetrica, e sono stati dati diversi suggerimenti per migliorare la sua robustezza e sicurezza.

# Autori
* Zhang Yihang: [Github](https://github.com/Accout-Personal)
* Scalella Simone: [Github](https://github.com/Simone-Scalella)
