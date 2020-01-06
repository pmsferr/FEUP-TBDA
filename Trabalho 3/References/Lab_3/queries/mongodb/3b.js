db.facilities.aggregate([
{
  	$unwind: "$MUNICIPALITIES"
},
{
  	$unwind: "$MUNICIPALITIES.ACTIVITIES"
},
{
  	$unwind: "$MUNICIPALITIES.ACTIVITIES.FACILITIES"
},
{
  	$match: {"MUNICIPALITIES.ACTIVITIES.FACILITIES.ROOMTYPE": /.*touros*./}
},
{
	$group: {_id: {region: "$MUNICIPALITIES.REGION",
				   name: "$MUNICIPALITIES.ACTIVITIES.FACILITIES.NAME"
				  }
			}
},
{
	$group: {_id: "$_id.region",
	  		 count: {"$sum": 1} 
	  		}
},
{
	$sort: {_id: 1}
}
])