from django.contrib import admin
from .models import Person, Marriage

@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'gender', 'birth_date')
    search_fields = ('first_name', 'last_name')
    # This allows you to set parents directly in the list view
    list_filter = ('gender',)

admin.site.register(Marriage)
