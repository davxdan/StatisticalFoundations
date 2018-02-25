	proc ttest data=SamoaEmployees sides=2;
		class EmploymentStatus;
		var Age;