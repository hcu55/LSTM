# Generated by Django 3.2.18 on 2023-03-18 14:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('lstm_api', '0002_userbabyrelationship_relation'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='is_staff',
            field=models.BooleanField(default=False),
        ),
    ]
