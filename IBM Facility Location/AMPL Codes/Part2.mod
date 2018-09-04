param C >= 0; # No. of Customers
param H >= 0; # No. of Hubs
param P >= 0; # No. of Products
param W >= 0; # Number of Service Level window
param WH >= 0; # No of ware houses
param cost_HtoWH {h in 0..H, wh in 0..WH} >= 0; # Cost ub to warehouse
param cost_WHtoC {wh in 0..WH, c in 0..C} >=0; # cost Warehouse to customer
#param Demand {c in 0..C, p in 0..P} := floor(Uniform(500,1000)); # Product Demand at a Customer
param Demand {c in 0..C, p in 0..P} >=0;
param ProdDemand{p in 0..P} = sum{c in 0..C} Demand[c,p];
#param HubCost{h in 0..H} := 10000; # Facility Fixed Cost
#param WHCost {wh in 0..WH} := 5000; # Warehouse opening cost
param HubCost{h in 0..H} >= 0; # Facility Fixed Cost
param WHCost {wh in 0..WH} >= 0; # Warehouse opening cost
param alpha{c in 0..C, p in 0..P, w in 1..W} =0.5; # Service Level (to be generated)
param delta{wh in 0..WH, c in 0..C, w in 1..W} >= 0; # Using Only Service Window 1
param M := 1000000; #Big M
param u {c in 0..C, p in 1..P} >= 0;

var HubOpen {h in 0..H} binary; # Hub Open or not
var WarehouseOpen {wh in 0..WH} binary; # Warehouse open or not
var HubDemand {h in 0..H, wh in 0..WH, p in 0..P} >= 0;
var WHFracDemand {wh in 0..WH, c in 0..C, p in 0..P} >=0 <=1;
#var WHDemand {wh in 0..WH, p in 0..P} >=0;

minimize TotalCost:
sum{h in 0..H} HubCost[h]*HubOpen[h] + sum {wh in 0..WH} WHCost[wh]*WarehouseOpen[wh] +
sum {h in 0..H, wh in 0..WH, p in 0..P} cost_HtoWH[h,wh]* HubDemand[h,wh,p] +
sum{wh in 0..WH, c in 0..C, p in 0..P} cost_WHtoC[wh,c]* WHFracDemand[wh,c,p] * Demand[c,p];

minimize Lagrangian:
sum{h in 0..H} HubCost[h]*HubOpen[h] + sum {wh in 0..WH} WHCost[wh]*WarehouseOpen[wh] +
sum {h in 0..H, wh in 0..WH, p in 0..P} cost_HtoWH[h,wh]* HubDemand[h,wh,p] +
sum{wh in 0..WH, c in 0..C, p in 0..P} cost_WHtoC[wh,c]* WHFracDemand[wh,c,p] * Demand[c,p] +
sum{c in 0..C, p in 0..P} u[c,p]*(1-sum{wh in 0..WH}WHFracDemand[wh,c,p]);

subject to Cust_DemandSatisfied {c in 0..C, p in 0..P}:
	sum {wh in 0..WH} WHFracDemand[wh,c,p] = 1;

subject to DemandConstraint {wh in 0..WH, p in 0..P}:
	sum {h in 0..H} HubDemand [h,wh,p]>= sum{c in 0..C} WHFracDemand[wh,c,p] * Demand[c,p];

subject to SupplyifHubOpen {h in 0..H, wh in 0..WH, p in 0..P}: # Disaggregated
	HubDemand[h,wh,p] <= HubOpen[h] * M;
	
subject to SupplyifWHOpen {wh in 0..WH, c in 0..C, p in 0..P}:
	WHFracDemand[wh,c,p] <= WarehouseOpen[wh];

subject to ServiceLevelConstraint {p in 0..P, w in 1..W, c in 0..C}:
	sum{wh in 0..WH} WHFracDemand[wh,c,p]*(Demand[c,p]/ProdDemand[p])*delta[wh,c,w] >= alpha[c,p,w];

#subject to NumberofFacilities: # Point 6th Constriant
#sum{f in 0..F} FacilityOpen[f] <= TotalFacilityOpen;

