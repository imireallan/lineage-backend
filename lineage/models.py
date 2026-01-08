from django.db import models

from django.db import models

class Person(models.Model):
    GENDER_CHOICES = [
        ('M', 'Male'),
        ('F', 'Female'),
    ]

    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    birth_date = models.DateField(null=True, blank=True)
    death_date = models.DateField(null=True, blank=True)
    
    # Self-referencing keys
    father = models.ForeignKey(
        'self', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='children_of_father'
    )
    mother = models.ForeignKey(
        'self', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='children_of_mother'
    )

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class Marriage(models.Model):
    person1 = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='marriages_1')
    person2 = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='marriages_2')
    marriage_date = models.DateField(null=True, blank=True)
    divorce_date = models.DateField(null=True, blank=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"Marriage: {self.person1} & {self.person2}"