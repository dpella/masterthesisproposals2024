# Embedding Fuzz-like language in linear Haskell

## Status 

    - Available
    - Level: master thesis 

## Company 

[DPella AB](www.dpella.io) is a deep tech startup that has developed a solution
to do privacy preserving analytics using Differential Privacy (DP) technology
(see below). DPella’s team of world experts (all with PhDs) in DP technology and
in building privacy-by-design and secure-by-design systems believe that this
technology is the best existing approach for doing privacy preserving analytics.  
This thesis will be carried out at DPella AB offices, Kungsgatan 11 - 6th floor,
41119 Gothenburg.

- DPella AB supervisor: Marco Gaboardi
- Chalmers supervisor: Prof. Alejandro Russo
- Possible examiner: Prof. David Sands

## Skills required to complete the thesis:
- Knowledge about Haskell programming language
- Type-level programming concepts like type-families, type classes, data kinds, and type
  constraints.
- Experience with designing domain specific languages

## Proposal 

[Differential privacy](https://link.springer.com/chapter/10.1007/11681878_14)
(DP) is emerging as a viable solution to release statistical information about
the population without compromising data subjects' privacy. A standard way to
achieve DP is by adding some statistical noise to the result of a data analysis.
If the noise is carefully calibrated, it provides *privacy* protection for the
individuals contributing their data.

A standard way to achieve DP is adding some carefully calibrated noise to the
result of a query. To protect all the different ways in which an individual's
data can affect the result of a query, the noise needs to be calibrated to the
maximal change that the result of the query can have when changing an
individual's data. This is formalized through the notion of **sensitivity**. The
sensitivity gives a measure of the amount of noise needed to protect one
individual's data.

### Queries as functions

Queries on a given table can be seen as functions of the form:

```haskell
query :: Table -> Result
```

For simplicity, we assume that the type `Table` is simply a list of records. To
give a concrete example about how a query can look like, let us assume
following table of allergic people at work,

| name | allergic |
| ---- | ------- |
| Alejandro | 1 |
| Marco     | 0 |
| Elisabet  | 1 |

where we assume that

```haskell
type Table = [Row]

data Row = MkRow
    {
      name    :: String
    , alergic :: Int
    }
```

In this example, we can write a query that computes the number of allergic people as follows:

```haskell
type Result = Int
countAllergic :: Table -> Int
countAllergic = sum . map alergic
```

### Reasoning about sensitivity of functions

To reason about sensitivity, we need to reason about what is the magnitude of
change that a query suffers when a record gets removed from the table.

The function `countAllergic` returns a count of `2` in the table above. However,
if we remove an individual and we consider the following table instead:

| name | allergic |
| ---- | ------- |
| Alejandro | 1 |
| Marco     | 0 |

`countAllergic` returns `1`. It seems that the variability is just about `1` --
you can verify that the same phenomenon occurs if you remove any other row in
the table we described first.

We can say that `countAllergic` has sensitivity **1**, but why? Observe that the
type of `countAllergic` indicates the co-domain are all the integers:

```haskell
countAlergic :: Table -> Int
```

but the range of the function is the set `{0,1}`! -- a range admits a
variability of 1. So, we know that if we remove one row from the table, then the
result will change, at most, by 1.

### Related work 

Several works have studied techniques to reason about program sensitivity by
typing, most of which in the context of differential privacy. An early approach
is the work by [Reed and Pierce](XXX). They designed an indexed linear type
system for differential privacy where types explicitly track sensitivities
thanks to types of the form $!_r A \multimap B$. In their work, this type can
only be assigned to terms representing functions from $A$ to $B$ which have
sensitivity less than $r$. Functions of these forms could be turned into
differentially private programs by adding noise carefully calibrated to $r$. The
type system by Reed and Pierce was implemented in the language Fuzz which was
also extended with a timed runtime to avoid side channels with respect to the
differential privacy guarantee [HaeberlenPN11](XXX). Automated type inference
for this type system was studied by D'Antoni \emph{et al.} [DAntoniGAHP13](XXX),
and its semantics foundation was studied by Azevedo de Amorim \emph{et al.}
[AmorimGHKC17](XXX).

Fuzz was further extended in several directions: Eigner and Maffei
[EignerM13](XXX) extended Fuzz to reason about distributed data and
differentially private security protocols. Gaboardi \emph{et al.}
[GaboardiHHNP13] extended Fuzz's type checker by means of a simple form of
dependent types. Winograd-Cort \emph{et al.}
[DBLP:journals/pacmpl/Winograd-CortHR17] extended Fuzz type checker and runtime
system to an adaptive framework. Zhang \emph{et al.} [ZhangRHP019] extended the
ideas of Fuzz to a three-level logic for reasoning about sensitivity for
primitives that are not captured in Fuzz. Azevedo de Amorim \emph{et al.}
[AmorimGHK19] add to Fuzz more general rules for reasoning about the sensitivity
of programs returning probability distributions. 

### Goal of the thesis 

The overall goal of to create a domain specific language capable to embed
Fuzz-like systems in linear Haskell. So, the contribution of the thesis will be: 

1. An embedded of Fuzz-like languages in linear Haskell
2. Understanding the differences in the semantics of linear types in Fuzz-like
   systems and linear Haskell. Are they compatible? 
3. Implementation of sensitivity examples (e.g., numbers, pairs, lists), what
   about generic recursive datatypes? 
4. Reasoning about the type-inference capabilities gotten for free with respect
   to related work
5. A small prototype that uses the sensitivity information to provide Differential Privacy queries

### What would you learn in this thesis? 

- Linear types 
- Linear Haskell 
- Differential Privacy concepts 
- Fuzz-like languages for Differential Privacy systems


