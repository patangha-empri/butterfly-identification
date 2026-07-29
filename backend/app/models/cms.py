import uuid
from datetime import datetime
from app.extensions import db


class CmsArticle(db.Model):
    __tablename__ = "cms_articles"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    title = db.Column(db.String(400), nullable=False)
    slug = db.Column(db.String(450), unique=True, nullable=False, index=True)
    content = db.Column(db.Text, nullable=False)
    excerpt = db.Column(db.String(500))
    cover_image_url = db.Column(db.String(500))

    # educational, facts, news, events
    article_type = db.Column(db.String(20), nullable=False, default="educational", index=True)

    # draft, published, archived
    status = db.Column(db.String(15), default="draft", nullable=False, index=True)

    author_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    published_at = db.Column(db.DateTime)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    # Relationships
    author = db.relationship("User", back_populates="cms_articles")

    __table_args__ = (
        db.Index("ix_cms_articles_status_type", "status", "article_type"),
    )

    def __repr__(self):
        return f"<CmsArticle {self.slug}>"

    def to_dict(self, include_content=False):
        data = {
            "id": self.id,
            "title": self.title,
            "slug": self.slug,
            "excerpt": self.excerpt,
            "cover_image_url": self.cover_image_url,
            "article_type": self.article_type,
            "status": self.status,
            "author": self.author.to_dict() if self.author else None,
            "published_at": self.published_at.isoformat() if self.published_at else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }
        if include_content:
            data["content"] = self.content
        return data


class CmsBanner(db.Model):
    __tablename__ = "cms_banners"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(300), nullable=False)
    image_url = db.Column(db.String(500), nullable=False)
    link_url = db.Column(db.String(500))
    # app_home, app_species, portal_home
    placement = db.Column(db.String(30), default="app_home", nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    display_order = db.Column(db.Integer, default=0, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "title": self.title,
            "image_url": self.image_url,
            "link_url": self.link_url,
            "placement": self.placement,
            "is_active": self.is_active,
            "display_order": self.display_order,
        }
