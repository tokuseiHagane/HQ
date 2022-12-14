from flask_jwt_extended import JWTManager
from flask_admin import Admin, BaseView, expose, AdminIndexView
from flask_admin.contrib.sqla import ModelView
from apispec.ext.marshmallow import MarshmallowPlugin
from flask_apispec.extension import FlaskApiSpec
from flask import Flask, request, render_template, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from apispec import APISpec
from os.path import isfile
from os import getenv
from sys import stdout


app = Flask(__name__)
# app.config.from_object(Config)
cors = CORS(app, resources={r"/*": {"origins": "*"}})
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://{}:{}@{}/{}'.format(
    getenv('DB_USER', 'flask'),
    getenv('DB_PASSWORD', 'example'),
    getenv('DB_HOST', 'db'),
    getenv('DB_NAME', 'appdb')
)
app.config['SECRET_KEY'] = 'anykey'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)

class Article(db.Model):
    __tablename__ = "article"

    id_article = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Text(255), unique=False, nullable=True)
    content = db.Column(db.Text(10000), nullable=False)
    time = db.Column(db.Time, nullable=False)
    id_source = db.Column(db.Integer, db.ForeignKey('source.id_source'), nullable=False)


class MediaSequence(db.Model):
    __tablename__ = "media_sequence"

    id_media_sequence = db.Column(db.Integer, primary_key=True)
    id_media = db.Column(db.Integer, db.ForeignKey('media.id_media'), nullable=True)
    id_article = db.Column(db.Integer, db.ForeignKey('article.id_article'), nullable=True)


class MediaType(db.Model):
    __tablename__ = "media_type"

    id_media_type = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.Text(255), unique=True, nullable=False)


class Media(db.Model):
    __tablename__ = "media"

    id_media = db.Column(db.Integer, primary_key=True)
    media_link = db.Column(db.String(190), unique=False, nullable=False)
    id_media_type = db.Column(db.Integer, db.ForeignKey('media_type.id_media_type'), nullable=False)



class SourceTag(db.Model):
    __tablename__ = "source_tag"

    id_source_tag = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.Text(255), unique=True, nullable=False)


class SourceTags(db.Model):
    __tablename__ = "source_tags"

    id_source_tags = db.Column(db.Integer, primary_key=True)
    id_source = db.Column(db.Integer, db.ForeignKey('source.id_source'), nullable=False)
    id_source_tag = db.Column(db.Integer, db.ForeignKey('source_tag.id_source_tag'), nullable=False)


class Source(db.Model):
    __tablename__ = "source"

    id_source = db.Column(db.Integer, primary_key=True)
    url = db.Column(db.String(190), unique=True, nullable=False)
    name = db.Column(db.Text(255), nullable=False)
    id_url_type = db.Column(db.Integer, db.ForeignKey('url_type.id_url_type'), nullable=True)


class UrlType(db.Model):
    __tablename__ = "url_type"

    id_url_type = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.Text(255), unique=False, nullable=False)

jwt = JWTManager(app)
docs = FlaskApiSpec()
app.config.update({
    'APISPEC_SPEC': APISpec(
        title='NEWScrapper',
        version='v1.0',
        openapi_version='2.0',
        plugins=[MarshmallowPlugin()],
    ),
    'APISPEC_SWAGGER_URL': '/swagger/'
})

@app.route('/')
def index():
    return '<a href="/admin/">Click me to get to Admin!</a>'


admin = Admin(app, name='NEWScrapper DB', template_mode='bootstrap3', endpoint='admin')
admin.add_view(ModelView(Article, db.session, name='Статьи'))
admin.add_view(ModelView(Media, db.session, name='Список всех вложений'))
admin.add_view(ModelView(MediaType, db.session, name='Тип вложения'))
admin.add_view(ModelView(Source, db.session, name='Источники статей'))
admin.add_view(ModelView(MediaSequence, db.session, name='Вложения статей'))
admin.add_view(ModelView(SourceTag, db.session, name='Список тэгов'))
admin.add_view(ModelView(SourceTags, db.session, name='Тэги источника'))
admin.add_view(ModelView(UrlType, db.session, name='Тип источника'))

docs.init_app(app)
jwt.init_app(app)


if __name__ == '__main__':
    db.create_all()
    app.run()
