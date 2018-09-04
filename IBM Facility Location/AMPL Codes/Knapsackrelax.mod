param C >= 0; # No. of Customers
param F >= 0; # No. of Facilities
param P >= 0; # No. of Products
param W >= 0; # No of service window
#param CPD := 20; #cost per unit distance
param distance{f in 1..F, c in 1..C, p in 1..P} >= 0; #Cost
param Demand{c in 1..C, p in 1..P} >= 0;
#param Demand{c in 1..C, p in 1..P} := floor(Uniform(0,20)); # Product Demand at a Customer
param ProdDemand{p in 1..P} = sum{c in 1..C} Demand[c,p];
param FacilityCost{f in 1..F} := 10000; # Facility Fixed Cost
param alpha{p in 1..P,w in 1..W} >= 0; # Service Level
param delta{f in 1..F, c in 1..C, w in 1..W} >= 0; # Using Only Service Window 1
param part_capacity{f in 1..F,p in 1..P}:= floor(Uniform(100,200));
#param part_capacity{f in 1..F,p in 1..P}:= floor(Uniform(0,250));
param fac_capacity{f in 1..F}:= sum {p in 1..P} part_capacity[f,p];
param u{c in 1..C, p in 1..P} >= 0; # Lagrangian multipliers

var FacilityOpen{f in 1..F} binary; # Facility Open or not
var FracDemand{f in 1..F, c in 1..C, p in 1..P} >= 0<=1;

minimize Lagrangian:
sum{f in 1..F} FacilityCost[f]*FacilityOpen[f] + 
sum{f in 1..F, c in 1..C, p in 1..P} distance[f,c,p]*Demand[c,p]*FracDemand[f,c,p]+
sum {c in 1..C, p in 1..P} u[c,p]*(1-sum {f in 1..F} FracDemand[f,c,p]);

minimize TotalCost:
sum{f in 1..F} FacilityCost[f]*FacilityOpen[f] + 
sum{f in 1..F, c in 1..C, p in 1..P} distance[f,c,p]*Demand[c,p]*FracDemand[f,c,p];

subject to DemandConstraint {c in 1..C, p in 1..P}:
sum{f in 1..F} FracDemand[f,c,p] = 1;

subject to SupplyifFacilityOpen {f in 1..F, c in 1..C, p in 1..P}: # Disaggregated
FracDemand[f,c,p] <= FacilityOpen[f];

subject to ServiceLevelSatisfiedConstraint {p in 1..P, w in 1..W}:
sum{f in 1..F, c in 1..C} FracDemand[f,c,p]*(Demand[c,p]/ProdDemand[p])*delta[f,c,w] >= alpha[p,w];

subject to capacityconstraint {f in 1..F}: #simple capacity constraint
sum{c in 1..C, p in 1..P} Demand[c,p]*FracDemand[f,c,p] <= FacilityOpen[f]*fac_capacity[f];

#subject to partcapacityconstraint {f in 1..F, p in 1..P}: # partwise capacity constraint
#sum{c in 1..C} Demand[c,p]*FracDemand[f,c,p] <= FacilityOpen[f]*part_capacity[f,p];
