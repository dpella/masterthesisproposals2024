# Sensitivity by Parametricity in Haskell: Functional Space 

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
is the work by [Reed and
Pierce](https://www.cis.upenn.edu/~bcpierce/papers/dp.pdf). They designed an
indexed linear type system for differential privacy where types explicitly track
sensitivities thanks to types of the form $!_r A \multimap B$. In their work,
this type can only be assigned to terms representing functions from $A$ to $B$
which have sensitivity less than $r$. Functions of these forms could be turned
into differentially private programs by adding noise carefully calibrated to
$r$. The type system by Reed and Pierce was implemented in the language Fuzz
which was also extended with a timed runtime to avoid side channels with respect
to the differential privacy guarantee
[HaeberlenPN11](https://haeberlen.cis.upenn.edu/papers/fuzz-sec2011.pdf).
Automated type inference for this type system was studied by D'Antoni et al.
[DAntoniGAHP13](https://haeberlen.cis.upenn.edu/papers/sensitivity-fpcdsl2013.pdf),
and its semantics foundation was studied by Azevedo de Amorim et al.
[AmorimGHKC17](https://arxiv.org/abs/1503.04522).

Fuzz was further extended in several directions: Eigner and Maffei
[EignerM13](https://ieeexplore.ieee.org/document/6595834) extended Fuzz to
reason about distributed data and differentially private security protocols.
Gaboardi \emph{et al.}
[GaboardiHHNP13](https://haeberlen.cis.upenn.edu/papers/dfuzz-popl2013.pdf)
extended Fuzz's type checker by means of a simple form of dependent types.
[Winograd-Cort et
al.](https://haeberlen.cis.upenn.edu/papers/adafuzz-icfp2017.pdf) extended Fuzz
type checker and runtime system to an adaptive framework. Zhang et al.
[ZhangRHP019](https://arxiv.org/abs/1905.12594) extended the ideas of Fuzz to a
three-level logic for reasoning about sensitivity for primitives that are not
captured in Fuzz. Azevedo de Amorim et al.
[AmorimGHK19](https://ieeexplore.ieee.org/document/8785715) add to Fuzz more
general rules for reasoning about the sensitivity of programs returning
probability distributions. 

Recent studies [Solo](https://dl.acm.org/doi/abs/10.1145/3563313) [Lobo et
al.](https://elobove.github.io/2021/src_icse21/) suggest that linear and complex
types in general are not strictly needed for the task of determining programs'
sensitivity. Notably, Solo introduced a system for static verification of
differential privacy where programs' sensitivity is determined with respect to a
set of data sources. However, the formal model presented in is inherently
*monomorphic* in the sensitivity environments, i.e. in the type indices,
creating a disconnect between what is used in the language and its formal model
-- something that manifest when [examining the polymorphic `sfoldr`
type-signature](https://zenodo.org/record/7079930), which is unsound.

Instead, Lobo et al. introduce **Spar**, a ready-to-use Haskell library aimed at
obtaining the sensitivity of user-defined functions via tracking the distance
between values and utilizing the type checker to provide evidence of how much a
program will amplify the inputs' distance -- thus offering a *direct proof of
function sensitivity*. Spar approach is rooted in a novel use of parametricity
that in combination with type constraints, and type-level numbers can verify the
sensitivity of functions -- including higher-order ones -- by simply
type-checking. 

When designing DSLs, it is often the case that either function space is
introduced in the DSL, i.e., `Exp (a -> b)`, or it is avoided given that the
host language's function space, i.e., `Exp a -> Exp b`, is sufficient to build
the type of programs one is interested in. Spar opted opted for the latter
approach. This design choice implies that functions of type `a -> b` do
not have an associated relational interpretation.


### Goal of the thesis 

To extend Spar with internalized function space, where it is expected to equip
our set of primitives with relational lambda abstractions and their respective
applications. Such an extension imposes significant implementation
challenges. 

So, the contribution of the thesis will be: 

1. Provide a relational lambda abstraction (`RLam`) and application (`RApp`)
   constructors for Spar 
2. The extension should have the expected currying/uncurrying behavior with
respect to each other, incidentally matching that of Fuzz's.
3. Some aspects of the library are *sallowed embedded* and assumed that terms
   are normalized when pattern matching, an assumption that gets broken with the
   introduction of `RApp` -- the result of an application can be a value of any
   type. To address this issue one should 
   - (i) apply *pattern matching* only to normalized expressions [Nachiappan et al.](https://www.cse.chalmers.se/~russo/publications_files/haskell21.pdf), 
   - (ii) making shallow embedded primitives as deep embedded and adapt the library, 
4. Write a generalized version of curry and uncurry w.r.t. Fuzz. 

### What would you learn in this thesis? 

- Advanced type-level programming techniques 
- Differential Privacy concepts 
- Fuzz-like languages for Differential Privacy systems


