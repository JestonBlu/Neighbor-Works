**Current Best Model**


**log(years) Final Model**: log(years) ~ Age + OwnRent + PoliceRating + FeelSafeDay + TrashRating + NeighborhoodID

**Latex version**
$y_{ijklmn} = \beta_0 + \beta_1(a) + \alpha_i + \gamma_j + \delta_k + \tau_l + \theta_m + e_{ijklmn}$

```
beta_0    -> overall mean
beta_1    -> age coefficient
a         -> age value
alpha_i   -> 1,2,3   (police rating: low, medium, high)
gamma_j   -> 1,2,3   (trash rating: low, medium, high)
delta_k   -> 1,2     (safety day rating: medium, high)
tau_l     -> 1,2,3   (Own/Rent: other, own, rent)
theta     -> 1,2,3,4 (Neighborhood)

e_{ijklm} -> model error N(0, \sigma^2)
```

------------------------------------

**log(years) Final Model**: log(years) ~ Age + OwnRent + PoliceRatingCat + FeelSafeDayCat + TrashRatingCat

**Latex version**
$y_{ijklm} = \beta_0 + \beta_1(a) + \alpha_i + \gamma_j + \delta_k + \tau_l + e_{ijklm}$

```
beta_0    -> overall mean
beta_1    -> age coefficient
a         -> age value
alpha_i   -> 1,2,3 (police rating: low, medium, high)
gamma_j   -> 1,2,3 (trash rating: low, medium, high)
delta_k   -> 1,2   (safety day rating: medium, high)
tau_l     -> 1,2,3 (Own/Rent: other, own, rent)
e_{ijklm} -> model error N(0, \sigma^2)
```

**log(Years) Model**

| Variable              | Order Removed | P-Value at Removal |
|:----------------------|:--------------|:-------------------|
| RecommendCat          | 1             | .844               |
| Gender                | 2             | .815               |
| NeighborhoodID        | 3             | .754               |
| FeelSafeNightCat      | 4             | .537               |
| SatLevelCat           | 5             | .486               |
| Race                  | 6             | .382               |
| SnowRemovalCat        | 7             | .622               |
| ParticipationScoreCat | 8             | .197               |



-----------------------------------------------------------

**Years Final Model**: years ~ Age + OwnRent + PoliceRating + FeelSafeDayCat

**Latex version**
$y_{ijkl} = \beta_0 + \beta_1(a) + \alpha_i + \gamma_j + \delta_k + e_{ijkl}$

```
beta_0   -> overall mean
beta_1   -> age coefficient
a        -> age value
alpha_i  -> 1,2,3 (Own/Rent: other, own, rent)
gamma_j  -> 1,2,3 (police rating: low, medium, high)
delta_k  -> 1,2,  (safety day rating: medium, high)
e_{ijkl} -> model error N(0, \sigma^2)
```

**Years Model**

| Variable              | Order Removed | P-Value at Removal |
|:----------------------|:--------------|:-------------------|
| SatLevelCat           | 1             | .914               |
| FeelSafeNightCat      | 2             | .836               |
| ParticipationScoreCat | 3             | .719               |
| RecommendCat          | 4             | .581               |
| NeighborhoodID        | 5             | .578               |
| TrashRatingCat        | 6             | .365               |
| Race                  | 7             | .175               |
| SnowRemovalCat        | 8             | .123               |
| Gender                | 9             | .090               |




-----------------------------------------------------------

The log(age) and age models ended up being the same so Im only writing it once, but i included the table of which variables were removed because the order was different.

**Age Model**: (Age or log(Age)) ~ Years + TrashRatingCat + FeelSafeNightCat


**Latex version**
$y_{ijk} = \beta_0 + \beta_1(a) + \alpha_i + \gamma_j + e_{ijk}$

```
beta_0   -> overall mean
beta_1   -> years coefficient
a        -> years value
alpha_i  -> 1,2,3 (trash rating: low, medium, high)
gamma_j  -> 1,2,3 (safety night rating: medium, high)
e_{ijkl} -> model error N(0, \sigma^2)
```

**log(Age) Model**

| Variable              | Order Removed | P-Value at Removal |
|:----------------------|:--------------|:-------------------|
| NeighborhoodID        | 1             | .956               |
| Gender                | 2             | .874               |
| FeelSafeDay           | 3             | .910               |
| SnowRemovalCat        | 4             | .594               |
| SatLevelCat           | 5             | .562               |
| PoliceRatingCat       | 6             | .449               |
| ParticipationScoreCat | 7             | .254               |
| RecommendCat          | 8             | .113               |
| Race                  | 9             | .081               |
| OwnRent               | 10            | .054               |

**Age Model**

| Variable              | Order Removed | P-Value at Removal |
|:----------------------|:--------------|:-------------------|
| NeighborhoodID        | 1             | .864               |
| SatLevelCat           | 2             | .817               |
| SnowRemovalCat        | 3             | .800               |
| Gender                | 4             | .561               |
| ParticipationScoreCat | 5             | .428               |
| FeelSafeDayCat        | 6             | .423               |
| PoliceRatingCat       | 7             | .379               |
| RecommendCat          | 8             | .094               |
| Race                  | 9             | .084               |
| OwnRent               | 10            | .139               |
